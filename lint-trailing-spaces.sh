#!/bin/bash
# Check if a the given input has trailing spaces.
#
# author: andreasl

grep -EHn --color '[[:space:]]+$' "$@" && exit 1
exit 0
