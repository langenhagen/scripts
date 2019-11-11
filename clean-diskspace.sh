#!/bin/bash
#
# Deletes superfluous storage-consuming directories and files and removes old packages.
#
# Input Parameters:
#   --wholesome (optional): calls `git gq --aggressive` on all .git folders (indirectly) under "/".
#
# author: andreasl

set -x;

# color codes
b='\e[1m'  # bold
n='\e[m'  # normal

# Empty Trash
dirsize=$(du -sh "$HOME/.local/share/Trash/" 2>/dev/null);
printf "${b}Info: $HOME/.local/share/Trash has the following size: ${dirsize}${n}\n";
rm -rfv "$HOME/.local/share/Trash/*";

# Gradle & related
dirsize=$(du -sh "$HOME/.gradle/caches" 2>/dev/null);
printf "${b}Info: $HOME/.gradle/caches has the following size: ${dirsize}${n}\n";
rm -rfv "$HOME/.gradle/caches";

dirsize=$(du -sh "$HOME/.gradle/daemon" 2>/dev/null);
printf "${b}Info: $HOME/.gradle/daemon has the following size: ${dirsize}${n}\n";
rm -rfv "$HOME/.gradle/daemon";  # TODO verify

dirsize=$(du -sh "$HOME/.m2/repository" 2>/dev/null);
printf "${b}Info: $HOME/.m2/repository has the following size: ${dirsize}${n}\n";
rm -rfv "$HOME/.m2/repository";

find ~ -iname '.gradle' -type d -exec rm -rf '{}' \;

# Buildout
dirsize=$(du -sh "$HOME/.buildout/download-cache" 2>/dev/null);
printf "${b}Info: $HOME/.buildout/download-cache has the following size: ${dirsize}${n}\n";
rm -rfv "$HOME/.buildout/download-cache";

dirsize=$(du -sh "$HOME/.buildout/eggs" 2>/dev/null);
printf "${b}Info: $HOME/.buildout/eggs has the following size: ${dirsize}${n}\n";
rm -rfv "$HOME/.buildout/eggs";

# Brew
command -v brew >/dev/null && brew cleanup -s;

# Apt
if [ "$(command -v apt)" ]; then
    sudo du -sh '/var/cache/apt/archives';
    sudo apt clean;
    sudo apt autoremove --purge;
    sudo apt autoremove;
fi

# dpkg
if [ "$(command -v dpkg)" ]; then
    sudo dpkg --purge --pending;
fi

# Docker
command -v docker >/dev/null && docker system prune --all --force;

# Git
find ~ -type d -name '.git' -exec bash -c "pushd '{}'; git gc; popd;" \;
if [[ "$1" == '--wholesome' ]]; then
   printf "${b}Do a  git gq --aggressive  on all git repos on the machine${n}\n";
   find / -type d -name '.git' -exec bash -c "pushd '{}'; git gc --aggressive; popd;" \;
fi

# Python
find ~ -name "*.py[co]" -delete;
find ~ -name '__pycache__' -delete;

# Jupyter
find ~ -name '.ipynb_checkpoints' -exec rm -rf '{}' \;
