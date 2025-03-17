#!/usr/bin/env python3
"""Find all files that have, except for a prefix, identical names.

author: andreasl
"""

import sys
from collections import defaultdict
from pathlib import Path


def main() -> None:
    directory = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")

    files_dict = defaultdict(list)

    n_prefix_chars = 5

    for file_path in directory.rglob("*"):
        if file_path.is_file():
            truncated_name = file_path.name[n_prefix_chars:]
            files_dict[truncated_name].append(str(file_path))

    for name, paths in files_dict.items():
        if len(paths) > 1:
            print(f"Duplicate files for '{name}':")
            for path in paths:
                print(f"  {path}")


if __name__ == "__main__":
    main()
