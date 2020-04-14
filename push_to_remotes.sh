#!/bin/bash
# Push to all remotes of the given git repo and take special care for gerrit remotes,
# including the py3 branches in CeleraoOne.
#
# author: andreasl

cd "$*" && git status || exit 1

remotes_and_urls_str="$(git remote -v | grep '(push)')"
mapfile -t remotes_and_urls <<< "$remotes_and_urls_str"
for remote_and_url in "${remotes_and_urls[@]}"; do

    remote="$(printf -- '%s' "$remote_and_url" | awk '{print $1}')"

    if [[ "$remote_and_url" == *"29418"* ]]; then
        # push to gerrit
        if [[ "$(git branch | grep '\*')" == *"py3" ]]; then
            push_output="$(git push "$remote" HEAD:refs/for/py3 2>&1)"
        else
            push_output="$(git push "$remote" HEAD:refs/for/master 2>&1)"
        fi

        # open according gerrit page in browser
        printf "$push_output" \
                | tee /dev/stderr \
                | grep -m1 -o 'https://.*' \
                | awk '{print $1}' \
                | xargs xdg-open
    else
        # default
        git push "$remote"
    fi
done
