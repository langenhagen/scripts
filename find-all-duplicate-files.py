#!/usr/bin/env python3
"""Find all duplicate files in a directory tree by size and content hash.

Usage:

  find-all-duplicate-files.py [<SEARCH_DIR>]

Examples:
  find-all-duplicate-files.py              # search for duplicates in the CWD
  find-all-duplicate-files.py /mnt/photos  # search for duplicates in /mnt/photos

author: andreasl

"""

import argparse
import hashlib
import os
import sys
from collections import defaultdict
from collections.abc import Generator
from pathlib import Path

MIN_FILES_FOR_DUPLICATE = 2


def get_file_size(path: Path) -> int | None:
    """Return file size, or None if inaccessible."""
    try:
        return path.stat().st_size
    except OSError:
        return None


def compute_hash(path: Path) -> str | None:
    """Return SHA256 hash of file, or None if inaccessible."""
    try:
        hasher = hashlib.new("sha256")
        with path.open("rb") as f:
            while chunk := f.read(8192):
                hasher.update(chunk)
        return hasher.hexdigest()
    except OSError:
        return None


def walk_files(root: Path) -> Generator[Path, None, None]:
    """Walk all files (including hidden) under root, yielding regular files."""
    for dirpath, _dirnames, filenames in os.walk(root):
        for filename in filenames:
            file_path = Path(dirpath) / filename
            if file_path.is_file() and not file_path.is_symlink():
                yield file_path


def find_all_duplicates(search_dir: Path) -> dict[str, list[Path]]:
    """Return dict mapping content hash to list of file paths with that hash."""
    size_groups: dict[int, list[Path]] = defaultdict(list)
    for file_path in walk_files(search_dir):
        size = get_file_size(file_path)
        if size is not None:
            size_groups[size].append(file_path)

    hash_groups: dict[str, list[Path]] = defaultdict(list)
    for candidates in size_groups.values():
        if len(candidates) < MIN_FILES_FOR_DUPLICATE:
            continue
        for candidate in candidates:
            h = compute_hash(candidate)
            if h is not None:
                hash_groups[h].append(candidate)

    return hash_groups


def main() -> int:
    """Program main entry point."""
    parser = argparse.ArgumentParser(
        description="Find all duplicate files in a directory tree.",
    )
    parser.add_argument(
        "search_dir",
        type=Path,
        nargs="?",
        default=Path.cwd(),
        help="Directory to search for duplicates (default: current working directory)",
    )

    args = parser.parse_args()

    hash_groups = find_all_duplicates(args.search_dir)

    duplicates = {
        h: paths
        for h, paths in hash_groups.items()
        if len(paths) >= MIN_FILES_FOR_DUPLICATE
    }
    if not duplicates:
        print("No duplicates found.")  # noqa: T201  print intentional for CLI output
        return 1

    for i, (hash_val, paths) in enumerate(duplicates.items()):
        if i > 0:
            print()  # noqa: T201  print intentional for CLI output
        print(f"{len(paths)} files with hash {hash_val}:")  # noqa: T201  CLI print
        for idx, path in enumerate(paths, start=1):
            print(f"  {idx}. {path}")  # noqa: T201  print intentional for CLI output

    return 0


if __name__ == "__main__":
    sys.exit(main())
