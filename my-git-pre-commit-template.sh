#!/bin/sh

# Git pre commit hook template
# It can be used for hook logic that should be called on your behalf but can be omitted if needed,
# e.g. long running operations
#
# author: langenhagen
# version: 17-09-14

echo 'Running GIT pre-commit hook...'
echo
echo 'Do you want to execute the git pre-commit hook? [Yy/Nn]'

exec < /dev/tty     # Allows us to read user input below, assigns stdin to keyboard

read -n 1 key
if [ "$key" != "y" ] && [ "$key" != "Y" ] ; then
    echo "You do not want to execute the pre-commit hook."
    exit 0
fi

# Custom git pre commit logic goes here...


# TODO add your logic here...


echo 'Pre-commit hook executed. Check and run git commit again.'

exit 1
