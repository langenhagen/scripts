#!/usr/bin/env python3
"""Given a file, find all duplicate files under a given directory.

author: andreasl
"""

import argparse
import hashlib
import sys
from pathlib import Path
from typing import Generator


def hash_file(file_path: Path, algo: str = "sha256") -> str:
    """Compute hash of the file at given path."""
    hasher = hashlib.new(algo)
    with file_path.open("rb") as f:
        while chunk := f.read(8192):
            hasher.update(chunk)
    return hasher.hexdigest()


def find_duplicates(file_path: Path, search_dir: Path) -> Generator[Path, None, None]:
    """Recursively find all duplicates of the file at given path in `search_dir`."""
    file_hash = hash_file(file_path)

    for candidate_path in search_dir.rglob("*"):
        if candidate_path.is_file() and candidate_path != file_path:
            if hash_file(candidate_path) == file_hash:
                yield candidate_path


def main() -> int:
    """Program main entry point."""
    parser = argparse.ArgumentParser(
        description="Find all duplicates of a given file in a given directory."
    )
    parser.add_argument(
        "file",
        type=Path,
        help="Path to the file",
    )
    parser.add_argument(
        "search_dir",
        type=Path,
        nargs="?",  # ?: a single argument, 0 or 1
        default=Path.cwd(),
        help="Directory to search for duplicates",
    )

    args = parser.parse_args()

    found_any = False
    for duplicate in find_duplicates(args.file, args.search_dir):
        print(duplicate)
        found_any = True

    if not found_any:
        print("No duplicates found.")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
