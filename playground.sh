#!/bin/bash
source ~/common.sh


echo-head 'PLAYGROUND.SH'


echo 'input params:      ' $@
echo
# YOUR CODE GOES HERE #########################################################

# from:
# https://www.gnu.org/software/grep/manual/html_node/Exit-Status.html
#
# Normally the exit status is 0 if a line is selected,
# 1 if no lines were selected, and 2 if an error occurred.
# However, if the -q or --quiet or --silent option is used and a line is selected,
# the exit status is 0 even if an error occurred.
# Other grep implementations may exit with status greater than 2 on error.

for VALUE in 0 1 3 ; do

    echo $VALUE

done

# END OF YOUR CODE ############################################################
echo-ok '✔'
