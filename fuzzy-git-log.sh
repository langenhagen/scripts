#!/bin/bash
# Preview and fuzzy search the git log.
#
# author: andreasl

git log \
    --format="%C(yellow)%h%C(red)%d%C(reset) %C(bold green)%ai %C(reset)%s %C(blue)<%an> %C(reset)" \
    --color=always | \
    fzf \
        --ansi \
        --no-sort \
        --preview 'printf "%s" {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I@ sh -c "git show -p --stat --color=always @"'
