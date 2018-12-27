#!/bin/bash
#
# Adds or updates file headers for different file types.
# Ideally, file headers may be retrieved from files from version control that are read into a
# variable, but they may as well be defined in this file.
#
# author: andreasl
# version: 18-12-27

# current copyright headers and regexes to match possibly outdated headers for each file type

c1_python_header=$(cat << HEADER_EOF
# -*- coding: utf-8 -*-
# (c) $(date +"%Y") CeleraOne GmbH
HEADER_EOF
)
c1_python_header_regexes=(
'# \-\*\- coding: utf\-8 \-\*\-'
'# (c).*CeleraOne GmbH'
)

c1_lua_header=$(cat << HEADER_EOF
-- -*- coding: utf-8 -*-
-- (c) $(date +"%Y") CeleraOne GmbH
HEADER_EOF
)
c1_lua_header_regexes=(
'\-\- \-\*\- coding: utf\-8 \-\*\-'
'\-\- (c).*CeleraOne GmbH'
)

function add_file_header {
    # usage:
    #   add_file_header <HEADER> <HEADER-REGEX> [--update] <file> [file] [...]

    # 1. determine whether file has old_header
    if [ -z ${old_header} ] ; then
    #   add header
    elif [ "${3}" == '--update' ] ; then
    #   remove old header using sed and regexes
    #   add header
    fi
}

# 1. fetch staged files
staged_files_string=$(git diff --name-only --cached)
mapfile -t staged_files_array <<< "${staged_files_string}"

for file in "${staged_files_array[@]}" ; do
    # 2. for all files determine filetype and dispatch to add header / else pass
    echo $file
done
