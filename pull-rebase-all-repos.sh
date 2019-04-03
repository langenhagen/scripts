#!/bin/bash
#
# For each pair in a mapping of git repo paths and branch names,
# check out on this branch,
# then call git fetch --prune and git pull --rebase origin,
# and report and abort if there is any error on the way.
# If there are no errors catched, run git status for each pair in the mapping afterwards.
#
# author: andreasl

# Source a list named repo_paths2default_branch_names of all repos that will be worked with
if [ $# -eq 0 ]; then
    . "$HOME/.gitprojectsrc"
elif [ $# -eq 1 ]; then
    . "$1"
else
    exit 1
fi

# color codes; overwrite with empty string '' if you want to disable them
r='\e[0;31m'
b='\e[1m'
rb='\e[1;31m'
n='\e[0m'

function die {
    # Will be called on failure
    printf "${1}"
    printf "cd ${repo_path}" | xclip -i -f -selection primary | xclip -i -selection clipboard
    printf "Command 'cd ${repo_path}' written to system clipboard\n"
    exit "${2}"
}

n_current_repo=0
n_all_repos=${#repo_paths2default_branch_names[@]}
for repo_path in "${!repo_paths2default_branch_names[@]}"; do
    local_branch_name="$(local_branch "${repo_path}")"

    (( n_current_repo += 1 ))
    printf "${b}(${n_current_repo}/${n_all_repos}) ${repo_path}...${n}\n"

    if ! cd "${repo_path}"; then
        printf "${r}Error: Path ${rb}${repo_path}${r} does not exist${n}\n"
        exit 1
    fi

    if ! git rev-parse --verify "${local_branch_name}" 1>/dev/null 2>&1; then
        output="${r}Error: The repo ${rb}${repo_path}${r} does not contain a branch called"
        output="${output} ${rb}${local_branch_name}${n}\n"
        die "${output}" 2
    fi

    if ! git checkout "${local_branch_name}"; then
        output="${r}Error: Could not git checkout ${rb}${local_branch_name}${r} on"
        output="${output} ${rb}${repo_path}${n}\n"
        die "${output}" 3
    fi

    git fetch --prune
    git pull --rebase origin "${local_branch_name}"
    code="${?}"
    if [ "${code}" != 0 ] ; then
        output="${r}Error: git pull --rebase origin ${local_branch_name} on the repo"
        output="${output} ${rb}${repo_path}${r}"
        if [ "${code}" == 1 ] ; then
            output="${output} did not find this remote branch${n}\n"
            die "${output}" 4
        elif [ "${code}" == 128 ] ; then
            output="${output} caused a merge conflict${n}\n"
            die "${output}" 5
        else
            output="${output} caused an unknown error${n}\n"
            die "${output}" 6
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
