#!/bin/bash
# Given a directory, will call a given command in bash on all its git subdirectories recursively or
# down to a given number of directory levels.
#
# For usage type: $0 --help
#
# author: andreasl

script_name="${0##*/}"
IFS= read -r -d '' script_description << HELP_EOF
Usage:
  ${script_name} [-q|--quiet] [-d|--depth <number>] [<path>] [-- <command>]

Examples:
  ${script_name}                      # lists the found git repositories
  ${script_name} -d 2 -- ls           # lists the found git repositories and calls \`ls\`" from all git repos in this file level and one level below
  ${script_name} -q -d 2 -- ls        # calls \`ls\` from all git repos in this file level and one level below but does not list the found git repos
  ${script_name} -p path/to/dir -- ls # calls \`ls\` from all git repos below the given path
  ${script_name} -q -- realpath .     # prints the paths of all git repos below the current path
  ${script_name} -h                   # prints the usage message
  ${script_name} --help               # prints the usage message

Note:
  If you want to use subshell related-variables, like e.g. \$PWD, wrap them into single quotation
  marks so that they will not be expanded '' immediately.
HELP_EOF

use_maxdepth=false
search_dir='.'

while [ $# -gt 0 ]; do
    key="$1"
    case $key in
    -q|--quiet)
        quiet="True"
        ;;
    -d|--depth)
        use_maxdepth=true
        depth="${2}"
        shift # past argument
        ;;
    -p|--path)
        search_dir="${2}"
        shift # past argument
        ;;
    --)
        shift # past argument
        command="$*"
        break
        ;;
    -h|--help)
        printf -- "$script_description"
        exit 0
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

function function_called_by_find {
    [ -n "$quiet" ] || printf "\e[1m${PWD}\e[0m\n"
    eval "$command"
}

# export the function and the command, since the subshell you open below in find
# should know about the function and the command
export -f function_called_by_find
export quiet
export command

if [ "$use_maxdepth" == "true" ]; then
    find "$search_dir" -maxdepth "$depth" -type d -iname "*.git" -execdir \
        bash -c "function_called_by_find ;" \;
else
    find "$search_dir" -type d -iname "*.git" -execdir \
        bash -c "function_called_by_find ;" \;
fi
