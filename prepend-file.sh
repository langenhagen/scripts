#!/bin/bash
# author: andreasl

function show_help {
    script_name="${0##*/}"
    msg="${script_name}\n"
    msg+="Prepend a given string to a given file.\n"
    msg+="\n"
    msg+="Usage:\n"
    msg+="  ${script_name} <file> <<< <input-string>\n"
    msg+="  echo <input-string> | ${script_name} <file>\n"
    msg+="\n"
    msg+="Examples:\n"
    msg+="  ${script_name} script.py <<< '#!/usr/env/bin python3\\\n# -*- coding: utf-8 -*-'\n"
    msg+="  echo 'Step 0: ' | myfile.txt\n"
    printf "$msg"
}

inline=false
while [ "$#" -gt 0 ]; do
    case "$1" in
    -i|--inline)
        inline=true
        ;;
    -o|--output)
        output_file="$2"
        shift # past argument
        ;;
    -h|--help)
        show_help
        exit 0
        ;;
    *) # unknown option
        input_file="$1"
        ;;
    esac
    shift # past argument or value
done
if [ -z "$input_file" ]; then
    printf "Error: No input file specified.\n"
    exit 1
fi
if [ "$inline" == true ]; then
    output_file="$input_file"
fi
if [ -z "$output_file" ]; then
    printf "Error: No output file specified.\n"
    exit 1
fi

while IFS= read -rN1 character; do
    input_to_prepend+="$character"
done

file_content="$(<"$input_file")"
printf -- "$input_to_prepend" > "$output_file"
printf -- "$file_content" >> "$output_file"
