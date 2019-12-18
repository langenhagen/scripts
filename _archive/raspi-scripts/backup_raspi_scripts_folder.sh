#!/bin/sh

# deletes the old Dev/Scripts/raspi-scripts folder
# backs up the raspi scripts folder to the owncloud directory Dev/Scripts/raspi-scripts
# and forces a scan of the filesystem for user barn in order to sync the files to all machines
#
# author: langenhagen

echo "Really? Forces owncloud to re-scan the folders and that might take a while..."
echo "<ctrl+c> to escape or enter to proceed"
read THROW_AWAY_VAR

sudo rm -rf /mnt/barn_ext/oc/barn/files/Dev/Scripts/raspi-scripts/

sudo cp -r \
    /home/pi/scripts/   \
    /mnt/barn_ext/oc/barn/files/Dev/Scripts/raspi-scripts/


echo "`date`   Starting file-rescan for barn"

cd /var/www/owncloud
sudo -u www-data php occ files:scan barn

echo "`date`   File rescan finished"
