#!/bin/bash
#
# Given an optional reposet name,
# for each pair in a mapping of git repo paths and branch names,
# checkout the default branch name and
# call git push refs/for/branchnames.
#
# author: andreasl

# Source a list named repo_paths2default_branch_names of all repos that will be worked with
source "${HOME}/.reposets/reposets.inc.sh" "$1"

# color codes; overwrite with empty string '' if you want to disable them
r='\e[0;31m'
g='\e[0;32m'
b='\e[1m'
rb='\e[1;31m'
gb='\e[1;32m'
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
        output="${r}Error: The repo ${rb}${repo_path}${r} does not contain a branch called"
        output+=" ${rb}${local_branch_name}${n}\n"
        die "$output" 2
    fi

    if ! git checkout "$local_branch_name"; then
        output="${r}Error: Could not git checkout ${rb}${local_branch_name}${r} on"
        output+=" ${rb}${repo_path}${n}\n"
        die "$output" 3
    fi

    git remote update
    if [ "$(git rev-list --count origin/${local_branch_name}..${local_branch_name})" == '0' ]; then
        continue
    fi
    git push origin HEAD:"$(remote_push_branch "$repo_path")"
    code="$?"
    if [ "$code" == 0 ]; then
        remote_branch="origin $(remote_push_branch "$repo_path")"
        printf "${g}Pushed changes from ${gb}${repo_path}${g} to ${gb}${remote_branch}${n}\n"
    elif [ "$code" != 0 ] && [ "$code" != 1 ]; then  # 1 is "no new changes" on gerrit
        output="${r}Error: git push on the repo ${rb}${repo_path}${r} failed."
        if [ "$code" == 128 ]; then
            output+=" Do you have access rights?${n}\n"
            printf "$output"
            error_output+="$output"
        else
            output+=" failed with unknown reason.${n}\n"
            die "$output" 5
        fi
    fi
done

# *** all repos should be handled ***
printf "Checking status for all repos:\n"
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    printf "${b}${repo_path}${n}\n"
    cd "$repo_path" || die "Could not cd into ${repo_path}!" 6
    git status --short --untracked-files
done

>&2 printf "$error_output"
