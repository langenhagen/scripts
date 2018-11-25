#!/bin/bash
#
# Given a directory, will call a given command in bash on all its git subdirectories recursively or
# down to a given number of directory levels.
#
# For usage type: $0 --help
#
# author: andreasl
# version: 18-11-25

function show_usage {
    # Given the name of the script, prints the usage string.
    #
    # Usage:
    #   $0

    script_name="$(basename $0)"

    printf 'Usage:\n'
    printf "  ${script_name} [-d|--depth <number>] [<path>] [-- <command>]\n"
    printf '\n'
    printf 'Examples:\n'
    printf "  ${script_name}                      # lists the found git repositories\n"
    printf "  ${script_name} -d 2 -- ls           # calls \`ls\` from all git repos in this file level and one level below\n"
    printf "  ${script_name} -p path/to/dir -- ls # calls \`ls\` from all git repos below the given path\n"
    printf "  ${script_name} -- realpath .        # prints the paths of all git repos below the current path\n"
    printf "  ${script_name} -h                   # prints the usage message\n"
    printf "  ${script_name} --help               # prints the usage message\n"
}


use_maxdepth=false
search_dir='.'

while [ $# -gt 0 ] ; do
    key="$1"
    case ${key} in
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
        command="$@"
        shift # past argument
        ;;
    -h|--help)
        show_usage
        return 0
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

function function_called_by_find {
    printf "\033[1m${PWD}\033[0m\n"
    eval "${command}"
}

# export the function and the command, since the subshell should you open below in find
# should know about the function and the command
export -f function_called_by_find
export command

if [ ${use_maxdepth} == true ]; then
    find "${search_dir}" -maxdepth ${depth} -type d -iname "*.git" -execdir \
        bash -c "function_called_by_find ;" \;
else
    find "${search_dir}" -type d -iname "*.git" -execdir \
        bash -c "function_called_by_find ;" \;
fi
