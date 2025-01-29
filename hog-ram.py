#!/usr/bin/env python3
"""Eat some RAM.

Usage:

  ./hog-ram.py <size_in_MB>

author: andreasl
"""
from sys import argv, exit

if len(argv) < 2:
    print("Usage:\n\n  ./hog-ram.py <size_in_MB>")
    exit(1)

size_mb = int(argv[1])
size_bytes = size_mb * 1024 * 1024

print(f"Allocating {size_mb} MB of RAM...")

memory_hog = bytearray(size_bytes)

input("Press <Enter> to release memory")
exit(0)
