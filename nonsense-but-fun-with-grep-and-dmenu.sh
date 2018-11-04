#!/bin/bash


grepterm="$(printf '%s\n' "${choices[@]}" | dmenu -p "${selected_path}" -l 100)"
# grep -HIin "$grepterm" . | dmenu -l 100

find . -maxdepth 1 -type f -name "*" -exec grep -HIin "${grepterm}" '{}' \; | dmenu -l 100