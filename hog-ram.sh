#!/bin/bash
# Eat some RAM.
#
# Usage:
#
#   ./hog-ram.sh <size_in_MB>
#
# author: andreasl

size_mb=$1
[ -z "$size_mb" ] && { >&2 printf 'Usage:\n\n    %s <size_in_MB>\n\n' "$0"; exit 1; }

echo "Hogging ${size_mb} MB of RAM..."

declare -a memory_hog
# shellcheck disable=SC2034
memory_hog[0]=$(head -c "${size_mb}M" </dev/zero | tr '\0' 'x')

read -rp "Press <Enter> to release memory"
unset memory_hog
