#!/bin/bash
#
# Git pre commit hook template.
# It can be used for hook logic that should be called on your behalf but can be omitted if needed,
# e.g. long running operations.
#
# author: andreasl

echo 'Running GIT pre-commit hook...'
echo
echo 'Do you want to execute the git pre-commit hook? [Yy/Nn]'

exec < /dev/tty     # Allows us to read user input below, assigns stdin to keyboard

read -n 1 key
if [ "$key" != "y" ] && [ "$key" != "Y" ] ; then
    echo "You do not want to execute the pre-commit hook."
    exit 1
fi

# TODO add your custom git pre commit logic here, e.g.:
#
# staged_file_paths=$(git diff --name-only --cached)
# for file in ${staged_file_paths} ; do
#     echo "${file} will be committed."
# done


echo 'Pre-commit hook executed. Check and run git commit again.'

exit 0
