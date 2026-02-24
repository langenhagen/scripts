#!/usr/bin/env bash
# author: andreasl

show_help() {
    # Given the name of the script, prints the usage string.
    # Usage:
    #   ${FUNCNAME[0]}

    script_name="${0##*/}"

    msg="${script_name}"
    msg+="For each repo in a collection of git repo paths,\n"
    msg+="call a given command in bash on all its git subdirectories recursively or\n"
    msg+="down to a given number of directory levels.\n"
    msg+="\n"
    msg+="Usage:\n"
    msg+=" ${script_name} [-f|--file] [-q|--quiet] [-- <command>]\n"
    msg+="\n"
    msg+="Examples:\n"
    msg+="  ${script_name}                      # list all git repositories\n"
    msg+="  ${script_name} -f my                # source my.reposet instead of .reposet\n"
    msg+="  ${script_name} -- ls                # list all git repositories and calls \`ls\` on"
    msg+=" the path of all git repos\n"
    msg+="  ${script_name} -q -- ls             # call \`ls\` on the path of all git repos but do"
    msg+=" not list the git repos\n"
    msg+="  ${script_name} -q -- realpath .     # print the paths of all git repos\n"
    msg+="  ${script_name} -h                   # print the usage message\n"
    msg+="  ${script_name} --help               # print the usage message\n"
    msg+="\n"
    msg+="Note:\n"
    msg+="  If you want to use subshell related-variables, like e.g. \$PWD, wrap them into single"
    msg+=" quotation marks so that they will not be expanded '' immediately."
    printf "$msg"
}

reposet=
while [ $# -gt 0 ]; do
    key="$1"
    case $key in
    -f|--file)
        reposet="$2"
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
        show_help
        exit 0
        ;;
    *) # unknown option
        ;;
    esac
    shift # past argument or value
done

# Source a list named repo_paths2default_branch_names of all repos that will be worked with
source "${HOME}/.reposets/reposets.inc.sh" "$reposet"

n_all_repos=${#repo_paths2default_branch_names[@]}
n_current_repo=0
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    (( n_current_repo += 1 ))

    cd "$repo_path" || exit 1
    [ -n "$quiet" ] || printf "\e[1m(${n_current_repo}/${n_all_repos}) ${repo_path}\e[0m...\n"
    eval "$command"
done
