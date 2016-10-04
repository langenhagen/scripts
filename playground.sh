#!/bin/bash
source ~/common.sh


#export MY_CURRENT_PATH=`pwd`
#cd $MY_CURRENT_PATH


echo-head 'PLAYGROUND.SH'


echo $@
echo
# YOUR CODE GOES HERE #########################################################

# path_to_docker=$(which docker)

# if [ "$path_to_docker" == "" ]
# then
#     echo "$path_to_docker does not exist or is empty."
# else
#     echo "$path_to_docker exists"
# fi


# path_to_docker=$(which dockesr)

# if [ "$path_to_docker" == "" ]
# then
#     echo "$path_to_docker does not exist or is empty."
# else
#     echo "$path_to_docker exists"
# fi


if echo $HOME | grep -v -q "/Users/" ; then
    # Ensure we have the latest docker binary available (too old on Ubuntu 14.10)
    if test ! -x /usr/bin/docker || test ! -x /usr/local/bin/docker || docker --version | grep -q "1.0." ; then
        echo 'you should get the docker'
    fi
else
    echo 'ure on osx'
    if test -x /usr/local/bin/boot2docker ; then
        echo 'boot2docker shellinit'
    else
        echo ' # Seems like we use "Docker Toolbox", not the old boot2docker any more...
                eval "$(docker-machine env default)"'
    fi
fi



# END OF YOUR CODE ############################################################
echo-ok '✔'
