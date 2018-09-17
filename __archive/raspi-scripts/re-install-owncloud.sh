#!/bin/sh

# this lil script deletes the owncloud and re-installs it.
#
# TODO: document: is it complete?
#       are steps to be mentioned?
#
# author: langenhagen
# version: 170507

echo "Really?"
echo "<ctrl+c> to escape or enter to proceed"
read THROW_AWAY_VAR

sudo killall nginx

sudo rm -rf /var/www/owncloud
sudo mkdir -p /var/www/owncloud
cd /var/www/
sudo wget https://download.owncloud.org/community/owncloud-10.0.0.tar.bz2
sudo tar xjf owncloud-10.0.0.tar.bz2

sudo chown -R www-data:www-data /var/www



echo "Better reboot now"
