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

# if [ ! -d $E2E_ARTIFACTS ]; then
#     mkdir $E2E_ARTIFACTS
#     echo "here"
# fi


function myfunc()
{
    myresult='some value'
}

function myfunc3()
{
    myresult='fr value'
}

myfunc
echo $myresult
myfunc3
echo $myresult



# END OF YOUR CODE ############################################################
echo-ok '✔'
