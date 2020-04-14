#!/bin/bash
# Grep for a given process name and interactively kill one of the results.
#
# author: andreasl

mapfile -t processes <<< "$(ps aux | grep -i "$@")"
for key in "${!processes[@]}"; do
    echo "$((key + 1))    ${processes[$key]}";
done

read -e -p "Kill process with number: " key
pid="$(printf "${processes[$((key - 1))]}\n" | awk '{print $2}')"
kill "$pid"
