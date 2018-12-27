#!/bin/bash
#
# Deletes superfluous storage-consuming directories and files.
#
# Input Parameters:
#   --wholesome (optional): calls git `gq --aggressive` on all .git folders (indirectly) under "/".
#
# author: andreasl
# version: 18-12-27

set -x

dirsize=$(du -sh "~/.local/share/Trash/" 2>/dev/null)
printf "\033[1mInfo: ~/.local/share/Trash has the following size: ${dirsize}\033[0m\n"
rm -rfv "~/.local/share/Trash/*"

dirsize=$(du -sh ~/.gradle/caches 2>/dev/null)
printf "\033[1mInfo: ~/.gradle/caches has the following size: ${dirsize}\033[0m\n"
rm -rfv ~/.gradle/caches

dirsize=$(du -sh ~/.gradle/daemon 2>/dev/null)
echo "Info: ~/.gradle/daemon has the following size: ${dirsize}"
printf "\033[1mInfo: ~/.gradle/caches has the following size: ${dirsize}\033[0m\n"
rm -rfv ~/.gradle/daemon  # TODO verify

dirsize=$(du -sh ~/.m2/repository 2>/dev/null)
printf "\033[1mInfo: ~/.m2/repository has the following size: ${dirsize}\033[0m\n"
rm -rfv ~/.m2/repository

dirsize=$(du -sh ~/.buildout/download-cache 2>/dev/null)
printf "\033[1mInfo: ~/.buildout/download-cache has the following size: ${dirsize}\033[0m\n"
rm -rfv ~/.buildout/download-cache
dirsize=$(du -sh ~/.buildout/eggs 2>/dev/null)
printf "\033[1mInfo: ~/.buildout/eggs has the following size: ${dirsize}\033[0m\n"
rm -rfv ~/.buildout/eggs

command -v brew >/dev/null && brew cleanup -s

if [ "$(command -v apt)" ] ; then
    sudo du -sh /var/cache/apt/archives
    sudo apt clean
    sudo apt autoremove --purge
    sudo apt autoremove
fi

find ~ -iname '.gradle' -type d -exec rm -rf '{}' \;

find ~ -type d -name '.git' -exec bash -c "pushd '{}'; git gc; popd ;" \;
if [[ "$1" == "--wholesome" ]]; then
   printf "\033[1mDo a  git gq --aggressive  on all git repos on the machine\033[0m\n"
   find / -type d -name '.git' -exec bash -c "pushd '{}'; sudo git gc --aggressive; popd ;" \;
fi

command -v docker >/dev/null && docker system prune --all --force
