#!/bin/bash
# Remove all docker containers and images from the docker system.
#
# author: andreasl

sudo docker kill "$(docker ps -q)"
sudo docker rm "$(docker ps -a -q)"
sudo docker rmi "$(docker images -q)"

echo 'Docker purged.'

# a little more brutal - for Ubuntu / Linux:
# sudo umount /var/lib/docker/plugins
# sudo umount /var/lib/docker/overlay2
# sudo rm -rf /var/lib/docker/
# echo "Docker purged. Now you might need to reboot."
