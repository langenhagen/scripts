#!/bin/bash
#
# Adds or updates file headers for different file types.
# Ideally, file headers may be retrieved from files from version control that are read into a
# variable, but they may as well be defined in this file.
#
# author: andreasl

# copyright headers and regexes to match possibly existing headers for each file type

IFS='' read -r -d '' c1_python_header << HEADER_EOF
# -*- coding: utf-8 -*-
# (c) $(date +"%Y") CeleraOne GmbH
HEADER_EOF

c1_python_header_regexes=(
'# \-\*\- coding: utf\-8 \-\*\-'
'# \(c\).*CeleraOne GmbH'
)

IFS='' read -r -d '' c1_lua_header << HEADER_EOF
-- -*- coding: utf-8 -*-
-- (c) $(date +"%Y") CeleraOne GmbH
HEADER_EOF

c1_lua_regexes=(
'\-\- \-\*\- coding: utf\-8 \-\*\-'
'\-\- \(c\).*CeleraOne GmbH'
)

function add_file_header {
    # If a file header is missing, adds, or, if specified, updates a file's header.
    # It is given a string that will be added to the top of the file and an array of regexes
    # that will be used to check if possibly already existing headers exist and to delete them if
    # the flag --update is provided.
    #
    # usage:
    #   add_file_header <HEADER> <HEADER-REGEX> [--update] <file>

    header_string="$1"
    header_regexes="$2"                                      # TODO: how to pass an array to a function in bash?
    file="${4:-${3}}"

    # determine whether file has old_header, i.e. if it contains all regexes on consecutive lines

    if [ -z "$old_header" ] ; then
        # add header
        :
    elif [ "$3" == '--update' ] ; then
        for line in "${header_regexes[@]}"; do  # iterates safely over an array and retains whitespaces
            sed -i "0,/${line}/d" "$file"
        done
        # add header
    fi
}

mapfile -t staged_files_array <<< "$(git diff --name-only --cached)"
for file in "${staged_files_array[@]}"; do
    # TODO for all files determine filetype and dispatch to add header / else pass
    echo $file
done
