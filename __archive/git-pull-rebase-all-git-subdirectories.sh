#!/bin/bash
#
# Given a directory, will call git pull rebase on all its git subdirectories recursively or down to
# a given number of directory levels.
#
# Usage: $0 [-d|--depth <number>] [<path>]
#
# Examples:
#   $0                      # updates all git repos in the cwd and its subdirs
#   $0 -d 1                 # updates all git repos immediately under the cwd
#   $0 -d 3 path/to/dir     # updates all git repos in the given path up to 3 levels deep
#   $0 path/to/dir          # updates all git repos in the given dir and its subdirs
#
# author: andreasl

use_maxdepth=false
while [ $# -gt 1 ] ; do
    key="$1"
    case ${key} in
    -d|--depth)
        use_maxdepth=true
        depth="$2"
        shift # past argument
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

if [ $# -gt 0 ]; then
    search_dir="$1"
else
    search_dir='.'
fi

if [ ${use_maxdepth} == true ]; then
    find "$search_dir" -maxdepth ${depth} -type d -iname "*.git" -execdir \
        bash -c 'printf "\e[1m${PWD}\e[0m\n"; git pull --rebase; ' '{}' \;
else
    find "$search_dir" -type d -iname "*.git" -execdir \
        bash -c 'printf "\e[1m${PWD}\e[0m\n"; git pull --rebase; ' '{}' \;
fi
