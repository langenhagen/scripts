#!/bin/bash
#
# Given a directory, will call a given command in bash on all its git subdirectories recursively or
# down to a given number of directory levels.
#
# For usage type: $0 --help
#
# author: andreasl

function show_usage {
    # Given the name of the script, prints the usage string.
    #
    # Usage:
    #   ${FUNCNAME[0]}

    script_name="$(basename "$0")"

    output='Usage:\n'
    output="${output} ${script_name} [-q|--quiet] [-d|--depth <number>] [<path>] [-- <command>]\n"
    output="${output}\n"
    output="${output}Examples:\n"
    output="${output}  ${script_name}                      # lists the found git repositories\n"
    output="${output}  ${script_name} -d 2 -- ls           # lists the found git repositories and"
    output="${output} calls \`ls\` from all git repos in this file level and one level below\n"
    output="${output}  ${script_name} -q -d 2 -- ls        # calls \`ls\` from all git repos in"
    output="${output} this file level and one level below but does not list the found git repos\n"
    output="${output}  ${script_name} -p path/to/dir -- ls # calls \`ls\` from all git repos below"
    output="${output} the given path\n"
    output="${output}  ${script_name} -q -- realpath .     # prints the paths of all git repos"
    output="${output} below the current path\n"
    output="${output}  ${script_name} -h                   # prints the usage message\n"
    output="${output}  ${script_name} --help               # prints the usage message\n"
    output="${output}\n"
    output="${output}Note:\n"
    output="${output}  If you want to use subshell related-variables, like e.g. \$PWD, wrap them"
    output="${output} into single quotation marks so that they will not be expanded ''"
    output="${output} immediately.\n"
    printf "${output}"
}

use_maxdepth=false
search_dir='.'

while [ $# -gt 0 ] ; do
    key="$1"
    case ${key} in
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
        command="$@"
        break
        ;;
    -h|--help)
        show_usage
        exit 0
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

function function_called_by_find {
    [ -n "${quiet}" ] || printf "\e[1m${PWD}\e[0m\n"
    eval "${command}"
}

# export the function and the command, since the subshell you open below in find
# should know about the function and the command
export -f function_called_by_find
export quiet
export command

if [ "${use_maxdepth}" == "true" ]; then
    find "${search_dir}" -maxdepth "${depth}" -type d -iname "*.git" -execdir \
        bash -c "function_called_by_find ;" \;
else
    find "${search_dir}" -type d -iname "*.git" -execdir \
        bash -c "function_called_by_find ;" \;
fi
