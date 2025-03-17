#!/bin/bash
# Push to all remotes of the given git repo and take special care for company remotes
# Also, possibly open according websites for reviews.
#
# author: andreasl

remotes_and_urls_str="$(git remote -v | grep '(push)')"
mapfile -t remotes_and_urls <<<"$remotes_and_urls_str"
for remote_and_url in "${remotes_and_urls[@]}"; do
    remote="$(printf -- '%s' "$remote_and_url" | awk '{print $1}')"

    if [[ "$remote_and_url" == *'code.wabo.run'* ]] || [[ "$remote_and_url" == *'github.com:wandelbotsgmbh'* ]]; then
        # push merge-request to company GitLab
        local_branch="$(git rev-parse --abbrev-ref HEAD)"
        if [[ "$local_branch" =~ ^master$|^main$ ]]; then
            remote_branch="$(git log --oneline --format='%s' -n1 |
                sed -E 's/[^_a-zA-Z0-9-]+/-/g;s/^-+|-+$//g;s/./\L&/g')"
        else
            remote_branch="$local_branch"
        fi
        output="$(git push "$remote" HEAD:"$remote_branch" "$@" 2>&1)"
        printf '%s' "$output"
        if [[ "$output" == *' * [new branch] '* ]]; then
            set -o pipefail
            grep -E 'remote:[[:space:]]+http[s]*://' <<<"$output" |
                grep -o 'http.*$' |
                xargs xdg-open
        fi

    else
        # default
        git push "$remote" "$@"
    fi
done
