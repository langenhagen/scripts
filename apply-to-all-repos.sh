#!/bin/bash
#
# For each repo in a collection of git repo paths,
# call a given command in bash on all its git subdirectories recursively or
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
    output="${output} ${script_name} [-q|--quiet] [-- <command>]\n"
    output="${output}\n"
    output="${output}Examples:\n"
    output="${output}  ${script_name}                      # lists all git repositories\n"
    output="${output}  ${script_name} -- ls                # lists all git repositories and"
    output="${output} calls \`ls\` on the path of all git repos\n"
    output="${output}  ${script_name} -q -- ls             # calls \`ls\` on the path of all git"
    output="${output} repos but does not list the git repos\n"
    output="${output}  ${script_name} -q -- realpath .     # prints the paths of all git repos\n"
    output="${output}  ${script_name} -h                   # prints the usage message\n"
    output="${output}  ${script_name} --help               # prints the usage message\n"
    output="${output}\n"
    output="${output}Note:\n"
    output="${output}  If you want to use subshell related-variables, like e.g. \$PWD, wrap them"
    output="${output} into single quotation marks so that they will not be expanded ''"
    output="${output} immediately.\n"
    printf -- "${output}"
}

gitprojectsrc_file_path="$HOME/.gitprojectsrc"
while [ $# -gt 0 ] ; do
    key="$1"
    case ${key} in
    -f|--file)
        gitprojectsrc_file_path="$2"
        shift # past argument
        ;;
    -q|--quiet)
        quiet="True"
        ;;
    --)
        shift # past argument
        command="$*"
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

# Source a list named repo_paths2default_branch_names of all repos that will be worked with
. "$gitprojectsrc_file_path"

n_all_repos=${#repo_paths2default_branch_names[@]}
n_current_repo=0
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    (( n_current_repo += 1 ))

    cd "${repo_path}" || exit 1
    [ -n "${quiet}" ] || printf "\e[1m(${n_current_repo}/${n_all_repos}) ${repo_path}\e[0m...\n"
    eval "${command}"
done
