#!/bin/bash
source ~/common.sh


#export MY_CURRENT_PATH=`pwd`
#cd $MY_CURRENT_PATH


echo-head 'PLAYGROUND.SH'


echo $@
echo
# YOUR CODE GOES HERE #########################################################



path_to_docker=$(which docker)

if [ "$path_to_docker" == "" ]
then
    echo "$path_to_docker does not exist or is empty."
else
    echo "$path_to_docker exists"
fi


path_to_docker=$(which dockesr)

if [ "$path_to_docker" == "" ]
then
    echo "$path_to_docker does not exist or is empty."
else
    echo "$path_to_docker exists"
fi



# END OF YOUR CODE ############################################################
echo-ok '✔'
