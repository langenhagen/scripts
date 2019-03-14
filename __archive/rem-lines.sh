#!/bin/bash

# In every unstaged and staged file in in a git project,
# deletes every line that contains the string ' /rm'.
# Ignores untracked files.
#
# Note:
# the whole thing can be boiled down into a one-liner in bash:
#   sed -i '/ \/rm/d' $(git diff --name-only HEAD)
# or, in fish:
#   sed -i '/ \/rm/d' (git diff --name-only HEAD)
#
# Although, this script is safer, due to the fact that an arbitrary number of
# files can be handled, whereas the inline-solution may be affected by the `getconf ARG_MAX`,
# i.e. it may exceed the bash command line input limit.
#
#
# author: andreasl

files=`git diff --name-only HEAD`

printf 'These lines are to be deleted:\n\n'
for file in ${files}; do
    # TODO maybe use pygmentize to get colorized output
    grep -Hn --color ' /rm' "${file}"
done

echo
read -n1 -s -p 'Press any key to continue or ctr+c to abort' throwawaywar; echo

for file in ${files}; do
    sed -i '/ \/rm/d' "${file}"
done

