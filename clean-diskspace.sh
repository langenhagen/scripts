#!/bin/bash

# Deletes superfluous storage-consuming directories and files.
#
# Input Parameters:
#   --wholesome (optional): calls git `gq --aggressive` on all .git folders (indirectly) under "/".
#
# author: andreasl
# version: 18-08-22

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

find ~ -type d -name '.git' -exec sh -c "pushd '{}'; git gc; popd ;" \;

docker container prune --force

if [[ "$#" -ge "2" && "$2" == "--wholesome" ]]; then
   echo 'Do a git `gq --aggressive` on all git repos on the machine'
   find / -type d -name '.git' -exec sh -c "pushd '{}'; git gc --aggressive; popd ;" \;
fi
