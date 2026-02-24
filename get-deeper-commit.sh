#!/usr/bin/env bash
# From 2 given commits, print the commit that is deeper in the ancestry line.
#
# Usage:
#
#  get-deeper-commit.sh aaaaaa  bbbbbb      # prints `aaaaaa``, assuming aaaaaa is the older commit
#  get-deeper-commit.sh HEAD~4  HEAD~5      # prints `HEAD~5`
#
# author: andreasl

ancestry_path="$(git rev-list --ancestry-path "${1}..${2}")" || exit

[ -n "$ancestry_path" ] && echo "$1" || echo "$2"
