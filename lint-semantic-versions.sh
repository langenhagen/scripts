#!/bin/bash
#
# Retrieve the semantic version specifiactions that are under- or overspecified specified.
#
# author: andreasl

grep -HPn '=\s*\d+' "$@" | \
    grep -Pv '=\s*(\d+\.){2}\d+([\s,;]|$)' && exit 1
exit 0
