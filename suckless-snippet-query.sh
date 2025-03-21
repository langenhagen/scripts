#!/bin/bash
# Open a dmenu which prompts for any number of whitespace-separated search terms and suggests old
# queries.
# Grep iteratively in a certain hard coded file for lines that contain all of the given search
# terms and the special term '#snippet'.
# From these lines, the trimmed parts before the '#snippet' are presented in a second dmenu pass
# from which the user can select one.
# The raw selected item will be written to the system clipboard.
# This is a neat way of querying and retrieving snippets into any desktop environment.
#
# author: andreasl

query_history_file="${HOME}/.ssq_history"
historic_queries="$(tac "$query_history_file")"

query="$(printf "$historic_queries" | dmenu -i -l 5 -p "snippet query?:")"
if [ $? != 0 ]; then
    exit 1
fi

file="$JOURNAL_PATH"
results=$(grep -i '#snippet' "$file")
for searchterm in $query; do
    results="$(printf '%s' "$results" | grep -i "$searchterm")"
done

if [ -z "$results" ]; then
    exit 1
fi

selected_result="$(printf '%s\n' "${results[@]}" | sed 's/[ \t]*#snippet.*$//' | dmenu -i -p "select:" -l 30)"
if [ -z "$selected_result" ]; then
    exit 1
fi

sed -i "/${query}/d" "$query_history_file"
printf '%s\n' "$query" >>"$query_history_file"

printf '%s' "$selected_result" | head -1 | xclip -i -f -selection primary | xclip -i -selection clipboard
