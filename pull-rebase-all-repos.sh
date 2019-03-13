#!/bin/bash
#
# For each pair in a mapping of git repo paths and branch names,
# check out on this branch,
# then call git fetch --prune and git pull --rebase origin,
# and report and abort if there is any error on the way.
# If there are no errors catched, run git status for each pair in the mapping afterwards.
#
# author: andreasl

# This sources a list named repo_paths2default_branch_names of all repos that may be worked with
. "$HOME/.gitprojectsrc"

# color codes; overwrite with empty string '' if you want to disable them
r='\033[0;31m'
b='\033[1m'
rb='\033[1;31m'
n='\033[0m'

n_current_repo=0
n_all_repos=${#repo_paths2default_branch_names[@]}
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    default_branch_name="${repo_paths2default_branch_names[${repo_path}]}";

    (( n_current_repo += 1 ))
    printf "${b}(${n_current_repo}/${n_all_repos}) ${repo_path}${n}...\n"

    cd "${repo_path}"
    if [ $? != 0 ] ; then
        printf "${r}Error: Path ${rb}${repo_path}${r} does not exist${n}\n"
        exit 1
    fi

    git rev-parse --verify "${default_branch_name}" 1>/dev/null 2>&1
    if [ $? != 0 ] ; then
        output="${r}Error: The repo ${rb}${repo_path}${r} does not contain a branch called"
        output="${output} ${rb}${default_branch_name}${n}\n"
        printf "${output}"
        printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
        printf "Command 'cd ${repo_path}' written to system clipboard\n"
        exit 2
    fi

    git checkout "${default_branch_name}"
    if [ $? != 0 ] ; then
        output="${r}Error: Could not git checkout ${rb}${default_branch_name}${r} on"
        output="${output} ${rb}${repo_path}${n}\n"
        printf "${output}"
        printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
        printf "Command 'cd ${repo_path}' written to system clipboard\n"
        exit 3
    fi

    git fetch --prune
    git pull --rebase origin "${default_branch_name}"
    code="${?}"
    if [ "${code}" == 0 ] ; then
        continue
    elif [ "${code}" == 1 ] ; then
        output="${r}Error: git pull --rebase origin ${default_branch_name} on the repo"
        output="${output} ${rb}${repo_path}${r} did not find this remote branch${n}\n"
        printf "${output}"
        printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
        printf "Command 'cd ${repo_path}' written to system clipboard\n"
        exit 4
    elif [ "${code}" == 128 ] ; then
        output="${r}Error: git pull --rebase origin ${default_branch_name} on the repo"
        output="${output} ${rb}${repo_path}${r} caused a merge conflict${n}\n"
        printf "${output}"
        printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
        printf "Command 'cd ${repo_path}' written to system clipboard\n"
        exit 5
    else
        output="${r}Error: git pull --rebase origin ${default_branch_name} on the repo"
        output="${output} ${rb}${repo_path}${r} caused an unknown error${n}\n"
        printf "${output}"
        printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
        printf "Command 'cd ${repo_path}' written to system clipboard\n"
        exit 6
    fi
done

# *** all repos should be successfully rebased ***
printf "Checking status for all repos:\n"
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    printf "${b}${repo_path}${n}\n"
    git status --short --untracked-files
done
