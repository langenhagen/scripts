#!/bin/bash
#
# Deletes superfluous storage-consuming directories and files.
#
# Input Parameters:
#   --wholesome (optional): calls `git gq --aggressive` on all .git folders (indirectly) under "/".
#
# author: andreasl
# version: 19-02-08

set -x;

# color codes
b='\e[1m'  # bold
n='\e[m'  # normal

# Empty Trash
dirsize=$(du -sh "~/.local/share/Trash/" 2>/dev/null);
printf "${b}Info: ~/.local/share/Trash has the following size: ${dirsize}${n}\n";
rm -rfv "~/.local/share/Trash/*";

# Gradle & related
dirsize=$(du -sh ~/.gradle/caches 2>/dev/null);
printf "${b}Info: ~/.gradle/caches has the following size: ${dirsize}${n}\n";
rm -rfv ~/.gradle/caches;

dirsize=$(du -sh ~/.gradle/daemon 2>/dev/null);
printf "${b}Info: ~/.gradle/daemon has the following size: ${dirsize}${n}\n";
rm -rfv ~/.gradle/daemon;  # TODO verify

dirsize=$(du -sh ~/.m2/repository 2>/dev/null);
printf "${b}Info: ~/.m2/repository has the following size: ${dirsize}${n}\n";
rm -rfv ~/.m2/repository;

find ~ -iname '.gradle' -type d -exec rm -rf '{}' \;

# Buildout
dirsize=$(du -sh ~/.buildout/download-cache 2>/dev/null);
printf "${b}Info: ~/.buildout/download-cache has the following size: ${dirsize}${n}\n";
rm -rfv ~/.buildout/download-cache;

dirsize=$(du -sh ~/.buildout/eggs 2>/dev/null);
printf "${b}Info: ~/.buildout/eggs has the following size: ${dirsize}${n}\n";
rm -rfv ~/.buildout/eggs;

# Brew
command -v brew >/dev/null && brew cleanup -s;

# Apt
if [ "$(command -v apt)" ] ; then
    sudo du -sh /var/cache/apt/archives;
    sudo apt clean;
    sudo apt autoremove --purge;
    sudo apt autoremove;
fi

# Docker
command -v docker >/dev/null && docker system prune --all --force;

# Git
find ~ -type d -name '.git' -exec bash -c "pushd '{}'; git gc; popd ;" \;
if [[ "$1" == '--wholesome' ]]; then
   printf "${b}Do a  git gq --aggressive  on all git repos on the machine${n}\n";
   find / -type d -name '.git' -exec bash -c "pushd '{}'; sudo git gc --aggressive; popd ;" \;
fi

# Python
find ~ -name "*.py[co]" -delete;
find ~ -name "__pycache__" -delete;