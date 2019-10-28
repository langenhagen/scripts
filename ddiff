#!/bin/bash
#
# author: andreasl

script_name="${0##*/}"
IFS= read -r -d '' script_description << HELP_EOF
${script_name}
Compare file trees in a readable format using find, sort, and comm.

Note:
Might work incorrectly with directories and files whose names start with whitespaces.

Usage:
  compare-file-trees.sh [OPTIONS] <dir1> <dir2>
  compare-file-trees.sh <dir1> <dir2> [OPTIONS]

Options:
  -1, --in-1:               only show lines that are in dir1.
  -2, --in-2:               only show lines that are in dir2.
  -c, --color:              print colored output.
  -d --only-different:      show only directories/files that exist only in dir1 or only in di2.
  -e --exclude:             exclude glob pattern, e.g. "*.git".
  -h, --help:               print the the help message.
  -s --only-same:           show only directories/files that exist in both dir1 and dir2.
                            Same as -1 -2.

Examples:
  ${script_name} -e "*.git" -c -d dev dev_backup
  ${script_name} ~/Photos ~/Media -s
  ${script_name} --help
HELP_EOF

# parse command line arguments
excludes=
must_be_in_1=false
must_be_in_2=false
only_different=false
only_same=false
source_dir=.
target_dir=.
use_colors=false
while [ "$#" -gt 0 ] ; do
    case "$1" in
    -1|--in-1)
        must_be_in_1=true
        ;;
    -2|--in-2)
        must_be_in_2=true
        ;;
    -c|--color)
        use_colors=true
        ;;
    -d|--only-different)
        only_different=true
        ;;
    -e|--exclude)
        excludes+="-path ${2} -prune -o "
        shift
        ;;
    -h|--help)
        printf -- "$script_description"
        exit 0
        ;;
    -s|--only-same)
        only_same=true
        ;;
    *) # unknown option
        source_dir="$1"
        shift
        target_dir="$1"
        ;;
    esac
    shift
done

# get the file trees and do the comparisons
tree1="$(find "$source_dir" $excludes -printf "%P\n" | sort)"
tree2="$(find "$target_dir" $excludes -printf "%P\n" | sort)"
output="$(comm <(printf '%s\n' "$tree1") <(printf '%s\n' "$tree2"))"

# postprocess the output from comm
output="$(sed -E  "s:(^[^\t].*):1   \1:g" <<< "$output")"
output="$(sed -E  "s:^\t{2}(.*):1 2 \1:g" <<< "$output")"
output="$(sed -E  "s:^\t{1}(.*):  2 \1:g" <<< "$output")"

# filter the output
if [ "$must_be_in_1" == 'true' ] || [ "$only_same" == 'true' ]; then
    output="$(sed '/^ /d' <<< "$output")"
fi
if [ "$must_be_in_2" == 'true' ] || [ "$only_same" == 'true' ]; then
    output="$(sed '/^.. /d' <<< "$output")"
fi
if [ "$only_different" == 'true' ]; then
    output="$(sed '/^1 2/d' <<< "$output")"
fi

# colorize output
if [ "$use_colors" == 'true' ]; then
    red='\\e[31m'
    green='\\e[32m'
    orange='\\e[33m'
    nc='\\e[0m'

    output="$(sed -E  "s:^1 2 (.*):${orange}1 2 \1${nc}:g" <<< "$output")"
    output="$(sed -E  "s:^1   (.*):${red}1   \1${nc}:g" <<< "$output")"
    output="$(sed -E  "s:^  2 (.*):${green}  2 \1${nc}:g" <<< "$output")"
fi

printf '%b\n' "$output"
