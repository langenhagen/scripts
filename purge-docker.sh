#!/usr/bin/env bash
# Remove all docker containers and images from the docker system.
#
# author: andreasl

sudo docker kill "$(docker ps --quiet)"
sudo docker rm "$(docker ps --all -quiet)"
sudo docker rmi "$(docker images --quiet)"

echo 'Docker purged.'

# a little more brutal - for Ubuntu / Linux:
# sudo umount /var/lib/docker/plugins
# sudo umount /var/lib/docker/overlay2
# sudo rm -rf /var/lib/docker/
# echo "Docker purged. Now you might need to reboot."
