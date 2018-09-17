# semiformal as-much-as-convenient automated steps to set up a fresh
# installation of a raspberry pi that is accustomed to my needs and
# is capable of running backups and owncloud
#
#author: langenhagen
#version: 170507

echo 'semiscript'
exit 0

# get the scripts
cp -r the raspi scripts to /home/pi/scripts

# install software
sudo apt-get update
sudo apt-get -y install fish tree vim git tig mc rsnapshot rsync ddclient

# get the dotfiles
git clone https://github.com/langenhagen/dotfiles.git
git fetch origin raspi
cd dotfiles
git checkout -b raspi
bash link-files.sh


#
# mount the harddrives as /mnt/barn_ext and
# /mnt/barn_bak respectively
#


#
# install owncloud / or maybe rather nextcloud?
#


#
# setup rsnapshot / rsync and cronjobs
#


#
# setup ddclient dyndns
#

# sudo reboot