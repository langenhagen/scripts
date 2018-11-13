#!/bin/bash
#
# Given a directory, will call a given command on all its git subdirectories recursively or down to
# a given number of directory levels.
#
# Usage: $0 [-d|--depth <number>] [<path>] [-- <command>]
#
# Examples:
#   $0                      # lists the found git repositories
#   $0 -d 2 -- ls           # calls `ls` from all git repos in this file level and one level below
#   $0 -p path/to/dir -- ls # calls `ls` from all git repos below the given path
#   $0 -- realpath .        # prints the `$PWD` variable for all git repos below the current path
#
# author: andreasl
# version: 18-11-13

use_maxdepth=false
search_dir='.'
while [ $# -gt 1 ] ; do
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
        shift # past argument
        command="$@"
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

function find_function {
    printf "\033[1m${PWD}\033[0m\n"
    eval "${command}"
}

# export the function and the command, since the subshell should you open below in find
# should know about the function and the command
export -f find_function
export command

if [ ${use_maxdepth} == true ]; then
    find "${search_dir}" -maxdepth ${depth} -type d -iname "*.git" -execdir \
        bash -c "find_function ;" \;
else
    find "${search_dir}" -type d -iname "*.git" -execdir \
        bash -c "find_function ;" \;
fi
