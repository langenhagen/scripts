#!/bin/bash
source ~/common.sh


#export MY_CURRENT_PATH=`pwd`
#cd $MY_CURRENT_PATH


echo-head 'PLAYGROUND.SH'


echo $@
echo
# YOUG CODE GOES HERE #########################################################


cd $OLYMPIA_MAIN_DIR/auto-core-sdk

git rev-parse --verify 1622 &>/dev/null
echo $?
echo ORWHAT

# git checkout -b a-OLYMP-4406s



# END OF YOUR CODE ############################################################
echo-ok '✔'
