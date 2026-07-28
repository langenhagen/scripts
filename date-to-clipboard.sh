#!/usr/bin/env bash
#
# Print either today's date in "YYYY-MM-DD" format and copy it to clipboard
# or, if an argument is given, print today's date in "<WEEKDAY>, <DAY> <MONTH> <YEAR>" format
#
# Usage:
#
#   date-to-clipboard.sh          # print and copy "YYYY-MM-DD" to clipboard
#   date-to-clipboard.sh weekday  # print and copy "<WEEKDAY>, <DAY> <MONTH> <YEAR>" to clipboard
#
# author: andreasl

if [ "$#" -gt 0 ]; then
    out="$(date '+%A, %d %B %Y')"
else
    out="$(date '+%Y-%m-%d')"
fi

command -v pbcopy >/dev/null && clip_cmd=(pbcopy) || clip_cmd=(xclip -selection clipboard)

printf '%s\n' "$out"
printf '%s' "$out" | "${clip_cmd[@]}"
