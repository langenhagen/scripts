#!/bin/bash
#
# Counts the lines of code on a list of git repositories using cloc and
# prepends the results with the current date, repository name, directory path and
# writes the results in csv-format to stdout.
# A line in the output will have the following format:
#   date,folder_name,folder_path,files,language,blank,comment,code
#
# Exits immediately in case of any error.
#
# Usage:
#   cloc-all-repos.sh
#
# author: andreasl

set -e

# Source a list named repo_paths2default_branch_names of all repos that will be worked with
. "$HOME/.gitprojectsrc"

for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    cd "${repo_path}"
    cloc --csv --quiet --vcs=git  | \
    sed "/\(^[A-Za-z]\|^$\)/d; s:^:$(date '+%Y-%m-%d'),$(basename "${repo_path}"),${repo_path},:g"
done
