#!/bin/bash

# Deletes superfluous storage-consuming directories and files.
#
# author: andreasl
# version: 18-07-30

set -x

echo 'Info: ~/.gradle/caches has the following size:'
du -sh ~/.gradle/caches
echo 'Info: ~/.gradle/daemon has the following size:'
du -sh ~/.gradle/daemon
echo 'Info: ~/.m2/repository has the following size:'
du -sh ~/.m2/repository

rm -rfv ~/.gradle/caches
rm -rfv ~/.gradle/daemon  # TODO verify
rm -rfv ~/.m2/repository


find ~/code -iname '.gradle' -type d -exec rm -rfv '{}' \;

docker container prune --force