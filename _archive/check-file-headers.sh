#!/usr/bin/env bash
# Check if the files touched in a given git revision contain the headers
# and print an error message if any of the files misses the correct header.
# Return the number of files with incorrect header.
#
# author: andreasl

git_rev="$1"

check_file_headers() {
    # Checks the first lines of the given files to match the according lines of a pattern array.
    # Prints the number of mismatches.
    # Usage:
    #  check_file_headers <files-array> <header-pattern-array>
    local -n files=$1
    local -n header_patterns=$2

    n_wrong_headers=0

    for file in "${files[@]}"; do

        i=1
        for pattern_line in "${header_patterns[@]}"; do
            file_contents="$(git show $git_rev:$file)"
            line_no="$(grep --max-count=1 -Ens "$pattern_line" <<< "$file_contents" | cut -d: -f1)"
            if [ "$line_no" != "$i" ]; then
                printf 'File "%s" lacks a correct header.\n' "$file"
                n_wrong_headers=$((n_wrong_headers + 1))
                break
            fi
            i=$((i + 1))
        done
    done
    printf '%s\n' "$n_wrong_headers"
}

n_errors=0

# python headers
python_header_patterns=(
'^# -\*- coding: utf-8 -\*-$'
'^# \(c\) ([0-9]{4} |)Andreas Langenhagen$'
)
python_files="$(git diff-tree --no-commit-id --name-only -r ${git_rev} | grep ".py$")"
mapfile -t python_files <<< "$python_files"
n_errors=$(( n_errors + $(check_file_headers python_files python_header_patterns) ))

# lua headers
lua_header_patterns=(
'^# -\*- coding: utf-8 -\*-$'
'^# \(c\) ([0-9]{4} |)CeleraOne GmbH$'
)
lua_files="$(git diff-tree --no-commit-id --name-only -r ${git_rev} | grep ".lua$")"
mapfile -t lua_files <<< "$lua_files"
n_errors=$(( n_errors + $(check_file_headers lua_files lua_header_patterns) ))

# error message and exit
IFS= read -r -d '' error_message << EOF

${n_errors} files have a wrong header.
Please add the right header to the files and commit again.
EOF

[ "$n_errors" -ne 0 ] && printf '%s\n' "$error_message"
exit "$n_errors"
