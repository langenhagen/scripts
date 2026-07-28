#!/usr/bin/env bash
# Remove all docker containers and images from the docker system.
#
# Usage:
#
#   purge-docker.sh
#
# author: andreasl

# shellcheck disable=SC2046  # container ids are whitespace-free; word splitting is wanted here
sudo docker kill $(docker ps --quiet)

sudo docker system prune --all --force --volumes

echo 'Docker purged.'

# a little more brutal - for Ubuntu / Linux:
# sudo umount /var/lib/docker/plugins
# sudo umount /var/lib/docker/overlay2
# sudo rm -rf /var/lib/docker/
# echo "Docker purged. Now you might need to reboot."
