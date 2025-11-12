#!/bin/bash
# List non-hidden files, non-binary files in a given directory, print their contents
# and write the output to the clipboard.
#
# author: andreasl

show_help() {
    script_name="${0##*/}"

    msg="${script_name}\n"
    msg+="List non-hidden, non binary files in a given directory, print their contents "
    msg+="and write the output to the clipboard.\n"
    msg+="\n"
    msg+="Usage: ${script_name} [OTIONS] [FILE]...\n"
    msg+="\n"
    msg+="Options:\n\n"
    msg+="  -d, --directory DIRECTORY   Specify the directory to search in (default: current directory)\n"
    msg+="  -e, --exclude-mode          Exclude specified files instead of including them\n"
    msg+="  -F, --only-filenames        Only list filenames instead of displaying file contents\n"
    msg+="  -h, --help                  Display this help message and exit\n"
    msg+="\n"
    msg+="Examples:\n\n"
    msg+="  ${script_name}                                  # list all files and print their contents under the CWD\n"
    msg+="  ${script_name} --directory ~/myproject          # list/print all files under ~/myproject\n"
    msg+="  ${script_name} -d ~/myproject '*.css'           # list/print all .css files in ~/myproject\n"
    msg+="  ${script_name} index.html script.js             # list/print all index.html and script.js files\n"
    msg+="  ${script_name} --exclude-mode README.md css     # list/print all files except README.md and all files under css/\n"
    msg+="  ${script_name} -e README.md --only-filenames    # list all files except README.md\n"
    msg+="  ${script_name} --help                           # show the help and exit\n"
    # shellcheck disable=SC2059
    printf "$msg"
}

directory='.'
inclusive=true
only_list_filenames=false
files=()
while [ "$#" -gt 0 ]; do
    case "$1" in
    -d | --directory)
        directory="$2"
        shift
        ;;
    -e | --exclude-mode)
        inclusive=false
        ;;
    -F | --only-filenames)
        only_list_filenames=true
        ;;
    -h | --help)
        show_help
        exit 0
        ;;
    *)
        files+=("${1##*/}")
        ;;
    esac
    shift
done

[ ${#files[@]} -eq 0 ] && inclusive=false

if [ "$only_list_filenames" == true ]; then
    #shellcheck disable=SC2016
    file_action='file="$1"; file --mime-type "$file" | grep -q "text" && printf "%s\n" "${file}"'
else
    #shellcheck disable=SC2016
    file_action='
        file="$1"
        if file "$file" | grep -q "text"; then
            printf "\n\n%s:\n\n" "${file}"
            cat "$file"
        fi
    '
fi

if [ "$inclusive" == true ]; then
    include_list=()
    for item in "${files[@]}"; do
        include_list+=('-name' "$item" '-o')
    done
    unset 'include_list[${#include_list[@]}-1]'

    find "$directory" -type f "${include_list[@]}" \
        -exec sh -c "$file_action" shell {} \; |
        xclip -fi -selection clipboard
else
    prune_list=()
    exclude_list=()
    for item in "${files[@]}"; do
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
        -exec sh -c "$file_action" shell {} \; |
        xclip -fi -selection clipboard
fi
