#!/usr/bin/env python
"""
Compare 2 given Pipfile.lock json files.

author: andreasl
version: 2021-02-04
"""

import argparse
import dataclasses
import json
from typing import Any, Dict, List, Optional, Tuple

OptionalStr = Optional[str]


@dataclasses.dataclass
class Comparison:
    """Define a comparison result between two versions of a dependency."""

    package_name: str
    version: OptionalStr
    other_version: OptionalStr

    @property
    def are_versions_equal(self) -> bool:
        """Return True if the contained versions are equal, otherwise return
        False."""
        return self.version == self.other_version


def parse_cli_arguments() -> Tuple[argparse.Namespace, List[str]]:
    """Parse the command line arguments."""
    description = "Compare 2 given Pipfile.lock files."
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("lockfile1", help="Path to a Pipenv.lock file")
    parser.add_argument("lockfile2", help="Path to another Pipenv.lock file")
    parser.add_argument(
        "-C",
        "--no-color",
        action="store_true",
        default=False,
        help="Don't use colors in output",
    )
    return parser.parse_known_args()


def compare_dependencies(
    lockfile: Dict[str, Any], other_lockfile: Dict[str, Any]
) -> List[Comparison]:
    """Compare the dependency libraries of 2 given dicts that contain data from
    Pipenv.lock files. Return a list of tuples, each tuple containing a
    dependency name, a boolean value whether the values are equal and the exact
    version strings to the first given lock file and the other given lock
    file."""

    default1 = lockfile["default"]
    dependencies1 = {name: data.get("version") for name, data in default1.items()}
    develop1 = lockfile["develop"]
    dependencies1.update({name: data.get("version") for name, data in develop1.items()})

    default2 = other_lockfile["default"]
    dependencies2 = {name: data.get("version") for name, data in default2.items()}
    develop2 = lockfile["develop"]
    dependencies2.update({name: data.get("version") for name, data in develop2.items()})

    keys = set(dependencies1.keys())
    keys.update(set(dependencies2.keys()))

    results = []
    for key in keys:
        version1 = dependencies1.get(key)
        version2 = dependencies2.get(key)
        results.append(Comparison(key, version1, version2))
    return results


def main():
    """Compare 2 given Pipenv.lock dependency entries and print the diff."""
    namespace, _ = parse_cli_arguments()

    with open(namespace.lockfile1) as file:
        lockfile = json.load(file)
    with open(namespace.lockfile2) as file:
        other_lockfile = json.load(file)

    comparisons = compare_dependencies(lockfile, other_lockfile)
    comparisons.sort(key=lambda obj: obj.package_name)
    for entry in comparisons:
        if entry.are_versions_equal:
            print(f"{entry.package_name} are both version: {entry.version}")
        else:
            output = (
                f"{entry.package_name} have different versions: "
                f"{entry.version} != {entry.other_version}"
            )
            if namespace.no_color:
                print(f"{output}")
            else:
                print(f"\033[31m{output}\033[0m")


if __name__ == "__main__":
    main()
