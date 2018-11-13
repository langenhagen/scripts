#!/bin/bash

# Deletes superfluous storage-consuming directories and files.
#
# Input Parameters:
#   --wholesome (optional): calls git `gq --aggressive` on all .git folders (indirectly) under "/".
#
# author: andreasl
# version: 18-10-29

set -x

dirsize=$(du -sh ~/.gradle/caches 2>/dev/null)
echo "Info: ~/.gradle/caches has the following size: ${dirsize}"
rm -rfv ~/.gradle/caches

dirsize=$(du -sh ~/.gradle/daemon 2>/dev/null)
echo "Info: ~/.gradle/daemon has the following size: ${dirsize}"
rm -rfv ~/.gradle/daemon  # TODO verify

dirsize=$(du -sh ~/.m2/repository 2>/dev/null)
echo "Info: ~/.m2/repository has the following size: ${dirsize}"
rm -rfv ~/.m2/repository

dirsize=$(du -sh ~/.buildout/download-cache 2>/dev/null)
echo "Info: ~/.buildout/download-cache has the following size: ${dirsize}"
rm -rfv ~/.buildout/download-cache
dirsize=$(du -sh ~/.buildout/eggs 2>/dev/null)
echo "Info: ~/.buildout/eggs has the following size: ${dirsize}"
rm -rfv ~/.buildout/eggs

command -v brew >/dev/null && brew cleanup -s

if [ "$(command -v apt)" ] ; then
    sudo du -sh /var/cache/apt/archives
    sudo apt clean
    sudo apt autoremove --purge
    sudo apt autoremove
fi

find ~ -iname '.gradle' -type d -exec rm -rfv '{}' \;

find ~ -type d -name '.git' -exec sh -c "pushd '{}'; git gc; popd ;" \;

if [[ "$#" -ge "1" && "$1" == "--wholesome" ]]; then
   echo 'Do a git `gq --aggressive` on all git repos on the machine'
   find / -type d -name '.git' -exec sh -c "pushd '{}'; git gc --aggressive; popd ;" \;
fi

command -v docker >/dev/null && docker container prune --force



