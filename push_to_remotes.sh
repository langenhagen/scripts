#!/bin/bash
# Push to all remotes of the given git repo and take special care for gerrit remotes,
# including the py3 branches in CeleraoOne.
#
# author: andreasl

cd "$*" || exit 1
git status || exit 2

remotes_and_urls_str="$(git remote -v | grep '(push)')"
mapfile -t remotes_and_urls <<< "$remotes_and_urls_str"
for remote_and_url in "${remotes_and_urls[@]}"; do

    remote="$(printf -- '%s' "$remote_and_url" | awk '{print $1}')"

    if [[ "$remote_and_url" == *"29418"* ]]; then
        # push to gerrit
        if [[ "$(git branch | grep '\*')" == *"py3" ]]; then
            git push "$remote" HEAD:refs/for/py3
        else
            git push "$remote" HEAD:refs/for/master
        fi
    else
        # default
        git push "$remote"
    fi
done
