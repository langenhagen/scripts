#!/bin/bash

#export MY_CURRENT_PATH=`pwd`
#cd $MY_CURRENT_PATH

source common.sh

echo-head 'PLAYGROUND.SH'

cd ~/code/olympia-prime/build/
echo `pwd`


echo $@
echo
# YOUG CODE GOES HERE #########################################################



bash /Users/langenha/code/scripts/easy.sh
varrr=$?
echo whats the status
echo $varrr

# END OF YOUR CODE ############################################################
echo-ok '✔'