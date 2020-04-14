#!/bin/bash
# Open a dmenu which prompts for any number of whitespace-separated search terms and suggest old
# queries.
# Grep iteratively the one-line-help.txt file for lines that contain all of the given search terms.
# This is a neat way of querying and retrieving snippets from the one-line-help.txt file.
#
# author: andreasl

query_history_file="${HOME}/.solhq_history"
historic_queries="$(tac "$query_history_file")"

query="$(printf "$historic_queries" | dmenu -i -l 5 -p "olh query?:" )"
[ $? != 0 ] && exit 1

file="${HOME}/Dev/Zeugs/one-line-help.txt"
results=$(<"$file")
for searchterm in ${query}; do
    results="$(printf '%s' "$results" | grep -i "$searchterm")"
done
[ -z "$results" ] && exit 1

selected_result="$(printf '%s\n' "${results[@]}" | dmenu -i -l 30 -p "select:")"
[ -z "$selected_result" ] && exit 1

sed -i "/${query}/d" "$query_history_file"
printf -- '%s\n' "$query" >> "$query_history_file"
