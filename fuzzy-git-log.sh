#!/usr/bin/env bash
# Preview and fuzzy search the git log.
#
# author: andreasl

git log \
    --format='%C(yellow)%h %C(red)%d% %C(bold green)%ai %C(reset)%s %C(blue)<%an> %C(reset)' \
    --color=always |
    fzf \
        --ansi \
        --multi \
        --no-sort \
        --preview 'printf "%s" {} | cut -d" " -f1 | xargs -I@ sh -c "git show -p --stat --color=always @"' \
        --reverse |
    sed -e 's/^[[:space:]]*//;s/[[:space:]]*$//'
