#!/bin/bash
source ~/common.sh


echo-head 'PLAYGROUND.SH'


echo 'input params:      ' $@
echo
# YOUR CODE GOES HERE #########################################################

cd ~/Desktop

# cat my_docker_out.txt | grep -c -Hirn 'ssegmentation'
# if [ $? == 0 ] ; then
#     echo "MAAAAUUU"
# fi

if grep -Hirn 'carlo' my_docker_out.txt; then
    echo is found
else
    echo is not found
fi


# END OF YOUR CODE ############################################################
echo-ok '✔'
