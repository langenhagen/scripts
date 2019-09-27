#!/bin/bash
#
# Retrieve the semantic version specifiactions from given files
# that are underspecified or overspecified.
#
# author: andreasl

grep -HPn '=\s*\d+' "$@" | \
    grep -Pv '=\s*(\d+\.){2}\d+([\s,;]|$)' && exit 1
exit 0
