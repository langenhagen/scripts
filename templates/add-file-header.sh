#!/bin/bash
#
# Adds or updates file headers for different file types.
# Ideally, file headers shall be retrieved from a file tat is read into a variable, but they may
# also be defined in this file
#
# author: andreasl
# version: 18-11-26


# copyright headers for each file type

celeraone_python_header=$(cat << HEADER_EOF
# -*- coding: utf-8 -*-
# (c) $(date +"%Y") CeleraOne GmbH
HEADER_EOF
)

celeraone_python_header=$(cat << HEADER_EOF
-- -*- coding: utf-8 -*-
-- (c) $(date +"%Y") CeleraOne GmbH
HEADER_EOF
)

# arrays of regexes that mark lines of copyright headers for each file type

celeraone_python_header_regexes=(
'# \-\*\- coding: utf\-8 \-\*\-'
'# (c).*CeleraOne GmbH'
)

celeraone_lua_header_regexes=(
'\-\- \-\*\- coding: utf\-8 \-\*\-'
'\-\- (c).*CeleraOne GmbH'
)




# write function add_file_header <HEADER> [--update] <file> [file] [...]

# use/write function remove_file_header -- also use sed and regexes

# 1. fetch staged files
# 2. for all lua files / for all python files
# 3. check where headers are missing or outdated
# 4. if outdated, add headers

# or

# 1. determine whether file has already a header
# 1.1 if no
# 1.1.1 add header
# 1.2. if yes
# 1.2.1. should header be updated
# 1.2.1.1 if no
# 1.2.1.1.1 do nothing
# 1.2.1.1 if yes
# 1.2.1.1.1 remove header using sed and regexes
# 1.2.1.1.2 add header

