#!/bin/bash
#
# Given an optional reposet name,
# for each pair in the mapping of git repo paths and branch names,
# check out on this branch,
# then call git fetch --prune and git pull --rebase origin,
# and report and abort if there is any error on the way.
# If there are no errors catched, run git status for each pair in the mapping afterwards.
#
# author: andreasl

# Source a list named repo_paths2default_branch_names of all repos that will be worked with
source "$HOME/.reposets/reposets.inc.sh" "$1"

# color codes; overwrite with empty string '' if you want to disable them
r='\e[0;31m'
b='\e[1m'
rb='\e[1;31m'
n='\e[0m'

die() {
    # Will be called on failure
    printf "$1"
    printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
    printf "Command 'cd ${repo_path}' written to system clipboard\n"
    exit "$2"
}

n_current_repo=0
n_all_repos=${#repo_paths2default_branch_names[@]}
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    local_branch_name="$(local_branch "$repo_path")"

    (( n_current_repo += 1 ))
    printf "${b}(${n_current_repo}/${n_all_repos}) ${repo_path}...${n}\n"

    if ! cd "$repo_path"; then
        printf "${r}Error: Path ${rb}${repo_path}${r} does not exist${n}\n"
        exit 1
    fi

    if ! git rev-parse --verify "$local_branch_name" 1>/dev/null 2>&1; then
        msg="${r}Error: The repo ${rb}${repo_path}${r} does not contain a branch called"
        msg+=" ${rb}${local_branch_name}${n}\n"
        die "$msg" 2
    fi

    if ! git checkout "$local_branch_name"; then
        msg="${r}Error: Could not git checkout ${rb}${local_branch_name}${r} on"
        msg+="${rb}${repo_path}${n}\n"
        die "$msg" 3
    fi

    git fetch --prune
    git pull --rebase origin "$local_branch_name"
    code="$?"
    if [ "$code" != 0 ]; then
        msg="${r}Error: git pull --rebase origin ${local_branch_name} on the repo"
        msg+=" ${rb}${repo_path}${r}"
        if [ "$code" == 1 ]; then
            msg+=" did not find this remote branch${n}\n"
            die "$msg" 4
        elif [ "$code" == 128 ]; then
            msg+=" caused a merge conflict${n}\n"
            die "$msg" 5
        else
            msg+=" caused an unknown error${n}\n"
            die "$msg" 6
        fi
    fi
done

# *** all repos should be successfully rebased ***
printf "Checking status for all repos:\n"
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    printf "${b}${repo_path}${n}\n"
    cd "$repo_path" || die "Could not cd into ${repo_path}!" 7
    git status --short --untracked-files
done
