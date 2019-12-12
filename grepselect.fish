#!/usr/bin/fish
# Select some of the recent output of grep -Hrn and open the according files in vim.
#
# author: andreasl

set command (history | head -1)
set files (eval $command | fzf -m | cut -d: -f1 | uniq)
printf '%s\n' -- $files
vim -p $files
