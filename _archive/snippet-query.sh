#!/usr/bin/env bash
#
# Given one or several input args,
# If there are any lines that contain matches for each input arg and the string '#snippet' in a
# certain hardcoded file,
# print all these lines to the output and write the first line to the clipboard.
#
# author: andreasl

file="${HOME}/Work/2018-CeleraOne/day-notes.md"
results=$(grep -i '#snippet' "$file")
for searchterm in "${@}"; do
    results="$(printf '%s' "$results" | grep -i "$searchterm")"
done

if [ -z "$results" ]; then
    exit 1
fi

printf "$results" | head -1 | xclip -i -f -selection primary | xclip -i -selection clipboard
printf '%s\n' "$results"
