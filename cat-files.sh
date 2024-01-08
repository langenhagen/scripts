#!/bin/bash
# List non-hidden files in a given directory, cat their contents
# and print the result to the screen and clipboard.
#
# author: andreasl
[ "$#" -lt 1 ] && { echo "Usage: $0 <directory> [exclude_list...]"; exit 1; }

directory="$1"
shift
prune_list=()
exclude_list=()
for item in "${@}"; do
    prune_list+=('-o' '-name' "$item")
    exclude_list+=('-a' '-not' '-name' "$item")
done

if [ "${#prune_list[@]}" -gt 0 ]; then
    unset 'prune_list[0]'
    #shellcheck disable=SC2124
    prune_str="( -type d ( ${prune_list[@]} ) -prune ) -o"
fi

#shellcheck disable=SC2086
find "$directory" \
    $prune_str \
    -type f -not -path '*/.*' "${exclude_list[@]}" \
    -exec sh -c '
        file="$1"
        if file "$file" | grep -q "text"; then
            printf "\n\n%s:\n\n" "${file}"
            cat "$file"
        fi
        ' shell {} \; \
    | xclip -fi -selection clipboard
