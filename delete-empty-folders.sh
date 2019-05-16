#!/bin/bash
#
# Finds all empty subfolders in a hardcoded directory
# and prompts the user whether to delete every individual empty folder,
# and does accordingly.
# Ignores everything inside .git dirs.
#
# author: andreasl

root_folder='/home/barn/Dev'  # adjust this

directory_array=()
while IFS=  read -r -d $'\0'; do
    directory_array+=("$REPLY")
done < <(find "$root_folder" -type d -print0)

for dir in "${directory_array[@]}" ; do
    if [[ "$dir" =~ .*\.git/.* ]] ; then
        continue
    fi
    is_empty=$(ls -A "$dir")
    if [ -z "$is_empty" ]; then
        echo "$dir"
        read -r -e -n1 -p " Delete [y/n]?: " do_delete  # -r raw, i.e. don't mangle backslashes -e newline after input is read  -n1 capture 1 character, no ENTER needed
        [ "$do_delete" == "y" ] && rm -rf "$dir"
    fi
done
