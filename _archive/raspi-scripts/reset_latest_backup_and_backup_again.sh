#!/bin/sh

# Deletes the last backup daily.0 and
# replaces it with the daily.1 one and
# triggers a new backup and then
# sends a pushover notification at the end
#
# author: langenhagen

echo "Really?"
echo "<ctrl+c> to escape or enter to proceed"
read THROW_AWAY_VAR

cd /mnt/barn_bak/_bak
sudo rm -rf daily.0
echo "`date`   'Deletion Done"
cp -al daily.1 daily.0
echo "`date`   Copying Done"

cd /home/pi/scripts
sudo bash backup_owncloud_daily.sh
echo "`date`   'Backup Done"

/usr/bin/curl -s \
              --form-string "token=anjdhkj51igvgxiwmkmg9i1iiioczd" \
              --form-string "user=ucw67xi5r5mqgqo8arh3p64xkj39wu" \
              --form-string "message=Reset Latest Backup and Backup Again Done" \
              https://api.pushover.net/1/messages.json
