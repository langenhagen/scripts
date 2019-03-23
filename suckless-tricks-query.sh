#!/bin/bash
#
# Opens a dmenu which prompts for any number of whitespace-separated search terms and suggests old
# queries.
# Greps iteratively the tricks.sh file for lines that contain all of the given search terms.
# These lines are presented in a second dmenu pass from which the user can select one.
# The raw selected item will be written to the system clipboard.
# This is a neat way of querying and retrieving snippets from the tricks.sh file.
#
# author: andreasl

query_history_file="${HOME}/.stq_history"
historic_queries="$(tac "${query_history_file}")"

query="$(printf "${historic_queries}" | dmenu -i -l 5 -p "tricks query?:" )"
if [ $? != 0 ] ; then
    exit 1
fi

file="${HOME}/Dev/Zeugs/tricks.sh"
results=$(cat "${file}")
for searchterm in ${query} ; do
    results="$(printf '%s' "${results}" | grep -i "${searchterm}")"
done

if [ -z "${results}" ] ; then
    exit 1
fi

selected_result="$(printf '%s\n' "${results[@]}" | dmenu -i -p "select:" -l 30)"
if [ -z "${selected_result}" ] ; then
    exit 1
fi

sed -i "/${query}/d" "${query_history_file}"
echo "${query}" >> "${query_history_file}"

printf '%s' "${selected_result}" | head -1 | xclip -i -f -selection primary | xclip -i -selection clipboard
