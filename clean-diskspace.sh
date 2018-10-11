#!/bin/bash

# Deletes superfluous storage-consuming directories and files.
#
# Input Parameters:
#   --wholesome (optional): calls git `gq --aggressive` on all .git folders (indirectly) under "/".
#
# author: andreasl
# version: 18-09-29

set -x

echo 'Info: ~/.gradle/caches has the following size:'
du -sh ~/.gradle/caches
rm -rfv ~/.gradle/caches
echo 'Info: ~/.gradle/daemon has the following size:'
du -sh ~/.gradle/daemon
rm -rfv ~/.gradle/daemon  # TODO verify
echo 'Info: ~/.m2/repository has the following size:'
du -sh ~/.m2/repository
rm -rfv ~/.m2/repository

command -v brew >/dev/null && brew cleanup -s

if [ "$(command -v apt)" ] ; then
    sudo du -sh /var/cache/apt/archives
    sudo apt clean
    sudo apt autoremove --purge
    sudo apt autoremove
fi

find ~/code -iname '.gradle' -type d -exec rm -rfv '{}' \;

find ~ -type d -name '.git' -exec sh -c "pushd '{}'; git gc; popd ;" \;

if [[ "$#" -ge "1" && "$1" == "--wholesome" ]]; then
   echo 'Do a git `gq --aggressive` on all git repos on the machine'
   find / -type d -name '.git' -exec sh -c "pushd '{}'; git gc --aggressive; popd ;" \;
fi

command -v docker >/dev/null && docker container prune --force



