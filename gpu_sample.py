#!/usr/bin/env python3
"""Sample per-process GPU usage on Apple Silicon without sudo.

Reads AGXDeviceUserClient accumulatedGPUTime from IORegistry, samples twice,
and prints processes sorted by GPU percent.

author: andreasl
"""

from __future__ import annotations

import argparse
import collections
import os
import plistlib

# nosec B404: Bandit warns on subprocess import; this script uses it only for
# a fixed /usr/sbin/ioreg command with shell=False.
import subprocess  # nosec B404
import time

MIN_GPU_PERCENT = 0.01
DEFAULT_INTERVAL_SECONDS = 0.5
DEFAULT_TOP = 0


def _gpu_ns(usage: object) -> int:
    """Return accumulated GPU nanoseconds from an AppUsage value."""
    if not isinstance(usage, list):
        return 0
    ns = 0
    for entry in usage:
        if isinstance(entry, dict):
            ns += int(entry.get("accumulatedGPUTime", 0) or 0)
    return ns


def sample() -> dict[int, dict[str, int | str]]:
    """Return per-pid accumulated GPU time in nanoseconds."""
    # nosec B603: subprocess args are a fixed list, not user input; shell=False.
    out = subprocess.check_output(  # nosec B603
        ["/usr/sbin/ioreg", "-r", "-d", "1", "-c", "AGXDeviceUserClient", "-a"],
    )
    data = plistlib.loads(out)
    items = data if isinstance(data, list) else [data]
    procs: dict[int, dict[str, int | str]] = collections.defaultdict(
        lambda: {"name": "", "ns": 0},
    )

    def walk(node: object) -> None:
        if isinstance(node, dict):
            creator = node.get("IOUserClientCreator")
            if isinstance(creator, str) and creator.startswith("pid "):
                try:
                    pid_s, name = creator[4:].split(", ", 1)
                    pid = int(pid_s)
                except ValueError:
                    pid = None
                    name = ""
                if pid is not None:
                    procs[pid]["name"] = name
                    procs[pid]["ns"] = int(procs[pid]["ns"]) + _gpu_ns(
                        node.get("AppUsage"),
                    )
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for value in node:
                walk(value)

    walk(items)
    return procs


def _parse_args() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--top",
        type=int,
        default=DEFAULT_TOP,
        metavar="N",
        help=(
            "Report only the top N GPU-using processes; 0 means all. "
            f"Default: {DEFAULT_TOP}."
        ),
    )
    parser.add_argument(
        "--pid",
        action="store_true",
        help="Print only the PID of each reported process.",
    )
    parser.add_argument(
        "--interval",
        type=float,
        default=DEFAULT_INTERVAL_SECONDS,
        metavar="SECONDS",
        help=f"Seconds between samples. Default: {DEFAULT_INTERVAL_SECONDS}.",
    )
    parser.add_argument(
        "--threshold",
        type=float,
        default=MIN_GPU_PERCENT,
        metavar="PERCENT",
        help=(
            "Ignore processes at or below this GPU percent. "
            f"Default: {MIN_GPU_PERCENT}."
        ),
    )
    parser.add_argument(
        "--show-interval",
        action="store_true",
        help="Print the measured sampling interval.",
    )
    return parser.parse_args()


def main() -> None:
    """Sample twice and print GPU-using processes sorted by GPU percent."""
    args = _parse_args()

    self_pid = os.getpid()
    sample1 = sample()
    time1 = time.time()
    time.sleep(args.interval)
    sample2 = sample()
    time2 = time.time()

    delta_t_ns = (time2 - time1) * 1e9
    rows: list[tuple[float, int, str]] = []
    for pid, proc2 in sample2.items():
        if pid == self_pid:
            continue
        ns1 = int(sample1.get(pid, {"ns": 0})["ns"])
        dns = max(0, int(proc2["ns"]) - ns1)
        pct = dns / delta_t_ns * 100 if delta_t_ns else 0.0
        if pct > args.threshold:
            rows.append((pct, pid, str(proc2["name"])))
    rows.sort(reverse=True)

    if args.top > 0:
        rows = rows[: args.top]

    # Ruff T201 flags print() calls; this CLI intentionally writes to stdout.
    if args.show_interval:
        print(f"interval_s={time2 - time1:.3f}")  # noqa: T201

    for pct, pid, name in rows:
        if args.pid:
            print(pid)  # noqa: T201
        else:
            print(f"{pct:6.2f}%  pid={pid:<7} {name}")  # noqa: T201


if __name__ == "__main__":
    main()
