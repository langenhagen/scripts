#!/usr/bin/env bash
# Push to all remotes of the given git repo and take special care for company remotes
# Also, possibly open according websites for reviews.
#
# Usage:
#
#   push_to_remotes.sh [<GIT-PUSH-ARG>...]
#
# Examples:
#
#   push_to_remotes.sh
#   push_to_remotes.sh --tags  # call `git push ... --tags`
#
# author: andreasl

remotes_and_urls_str="$(git remote -v | grep '(push)')"
remotes_and_urls=()
while IFS= read -r remotes_and_urls_line; do
    remotes_and_urls+=("$remotes_and_urls_line")
done <<<"$remotes_and_urls_str"
for remote_and_url in "${remotes_and_urls[@]}"; do
    remote="$(printf -- '%s' "$remote_and_url" | awk '{print $1}')"

    if [[ "$remote_and_url" == *'code.wabo.run'* ]] || [[ "$remote_and_url" == *'github.com:wandelbotsgmbh'* ]]; then
        # push merge-request to company GitLab
        local_branch="$(git rev-parse --abbrev-ref HEAD)"
        if [[ "$local_branch" =~ ^master$|^main$ ]]; then
            # lowercasing via `tr`, since sed's `\L` is a GNU extension. `LC_ALL=C` keeps
            # `a-zA-Z` strictly ASCII, so non-ASCII is slugged to `-` rather than surviving
            # the class and then not being lowercased by byte-oriented `tr`.
            remote_branch="$(git log --oneline --format='%s' -n1 |
                LC_ALL=C sed -E 's/[^_a-zA-Z0-9-]+/-/g;s/^-+|-+$//g' |
                tr '[:upper:]' '[:lower:]')"
        else
            remote_branch="$local_branch"
        fi
        output="$(git push "$remote" HEAD:"$remote_branch" "$@" 2>&1)"
        printf '%s' "$output"
        if [[ "$output" == *' * [new branch] '* ]]; then
            set -o pipefail
            grep -E 'remote:[[:space:]]+http[s]*://' <<<"$output" |
                grep -o 'http.*$' |
                xargs "$(command -v xdg-open || echo open)" # `xdg-open` on Gnome, `open` on macOS
        fi

    else
        # default
        git push "$remote" "$@"
    fi
done
