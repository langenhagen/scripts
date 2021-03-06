#!/bin/bash
# Count the lines of code on a set of git repositories using cloc and
# prepend the results with the current date, repository name, directory path and
# write the results in csv-format to stdout.
# A line in the output will have the following format:
#   date,folder_name,folder_path,files,language,blank,comment,code
#
# Note:
#  If a repo is defined several times in the reposets, it will also be checked several times.
#
# Usage:
#   cloc-all-repos.sh
#   cloc-all-repos.sh <reposet>...
#   cloc-all-repos.sh 1>loc.csv 2>/dev/null
#
# author: andreasl

reposet apply -q "$*" -- 'cloc --csv --quiet --vcs=git | sed "/\(^[A-Za-z]\|^$\)/d; s:^:$(date +%Y-%m-%d),${repo_path##*/},${repo_path},:g"'
