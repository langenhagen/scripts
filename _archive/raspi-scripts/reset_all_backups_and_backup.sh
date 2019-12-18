#!/bin/sh

echo "Really?"
echo "<ctrl+c> to escape or enter to proceed"
read THROW_AWAY_VAR

cd /mnt/barn_bak/
sudo rm -rf _bak
sudo mkdir -p _bak
echo "`date`   All Backup Files Deleted"

/usr/bin/curl -s \
              --form-string "token=anjdhkj51igvgxiwmkmg9i1iiioczd" \
              --form-string "user=ucw67xi5r5mqgqo8arh3p64xkj39wu" \
              --form-string "message=All Backups Deleted. Now Starting Backup." \
              https://api.pushover.net/1/messages.json

cd /home/pi/scripts
sudo bash backup_owncloud_daily.sh
echo "`date`   Backup Done"

/usr/bin/curl -s \
              --form-string "token=anjdhkj51igvgxiwmkmg9i1iiioczd" \
              --form-string "user=ucw67xi5r5mqgqo8arh3p64xkj39wu" \
              --form-string "message=Delete All Backups and Backup Done" \
              https://api.pushover.net/1/messages.json
