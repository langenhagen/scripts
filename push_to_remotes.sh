#!/bin/bash
# Push to all remotes of the given git repo and take special care for gerrit and company gitlab
# remotes. Also, possibly open according websites for reviews.
#
# author: andreasl

cd "$*" && git status || exit 1

remotes_and_urls_str="$(git remote -v | grep '(push)')"
mapfile -t remotes_and_urls <<< "$remotes_and_urls_str"
for remote_and_url in "${remotes_and_urls[@]}"; do
    remote="$(printf -- '%s' "$remote_and_url" | awk '{print $1}')"

    if [[ "$remote_and_url" == *'29418'* ]]; then
        # push to gerrit
        remote_and_branch="$(git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)")"
        remote_branch="${remote_and_branch/$remote\//}"
        if [ -n "$remote_branch" ]; then
            output="$(git push "$remote" HEAD:refs/for/"$remote_branch" 2>&1)"
        else
            output="$(git push "$remote" HEAD:refs/for/master 2>&1)"
        fi

        set -o pipefail
        printf '%s' "$output" \
            | tee /dev/stderr \
            | grep -m1 -o 'https://.*' \
            | awk '{print $1}' \
            | xargs xdg-open

    elif [[ "$remote_and_url" == *'gitlab.bof.mm.local'* ]] && [[ "$remote_and_url" != *'alangenhagen'* ]]; then
        # push merge-request to company gitlab
        local_branch="$(git rev-parse --abbrev-ref HEAD)"
        if [[ "$local_branch" =~ ^master$|^develop$ ]]; then
            remote_branch="$(git log --oneline --format='%s' -n1 \
                | sed -E 's/[^_a-zA-Z0-9-]+/-/g;s/^-+|-+$//g;s/./\L&/g')"
        else
            remote_branch="$local_branch"
        fi
        output="$(git push "$remote" HEAD:"$remote_branch" 2>&1)"
        printf '%s' "$output"
        if [[ "$output" == *' * [new branch] '* ]]; then
            set -o pipefail
            grep 'remote:   http[s]*://' <<< "$output" | grep -o 'http.*$' | xargs xdg-open
        fi

    else
        # default
        git push "$remote"
    fi
done
