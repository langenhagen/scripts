#!/bin/bash

# Finds all empty sub folders in the given directory
# prompts the user whether to delete every individual empty folder,
# and does accordingly.
#
# TODO: review
#
# author: andreasl
# version: 18-08-09

arr=()
while IFS=  read -r -d $'\0'; do
    arr+=("$REPLY")
done < <(find "/Users/langenha/personal/Dev/Cpp" -type d -print0)

# DOES NOT BREAK ON SPACES
for ((i = 0; i < ${#arr[@]}; i++)) do
    cur="${arr[$i]}"
    is_empty=$(ls -A "$cur")
    if [ -z "$is_empty" ]; then
        echo $cur
        read -e -n10 -p " Delete?: " dodelete  # -e newline after input is read  -n10 capture 10 characters, no ENTER needed
        if [ $dodelete == "y" ]; then
            rm -rf "$cur"
        fi
    fi
done