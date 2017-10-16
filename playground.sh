#!/bin/bash
source ~/common.sh


echo-head 'PLAYGROUND.SH'


echo 'input params:      ' $@
echo
# YOUR CODE GOES HERE #########################################################


mda=~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
#mda="~/Library/Application Support/Sublime Text 3/Cache"

echo $mda


if [ ! -L "$mda" ] && [ -d "$mda" ]; then
    echo "Is a real directory"
elif [ -L "$mda" ] && [ -d "$mda" ]; then
    echo "Is a symlink directory"
fi

# END OF YOUR CODE ############################################################
echo-ok '✔'
