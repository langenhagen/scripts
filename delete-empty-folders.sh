#!/bin/bash
#
# Finds all empty subfolders in a hardcoded directory
# and prompts the user whether to delete every individual empty folder,
# and does accordingly.
#
# author: andreasl

root_folder='/Users/langenha/personal/Dev/Cpp'  # adjust this

directory_array=()
while IFS=  read -r -d $'\0'; do
    directory_array+=("$REPLY")
done < <(find "${root_folder}" -type d -print0)

for ((i = 0; i < ${#directory_array[@]}; i++)) do
    current_directory="${directory_array[$i]}"
    is_empty=$(ls -A "${current_directory}")
    if [ -z "${is_empty}" ]; then
        echo "${current_directory}"
        read -r -e -n1 -p " Delete [y/n]?: " do_delete  # -r raw, i.e. don't mangle backslashes -e newline after input is read  -n1 capture 1 character, no ENTER needed
        if [ "${do_delete}" == "y" ]; then
            rm -rf "${current_directory}"
        fi
    fi
done
