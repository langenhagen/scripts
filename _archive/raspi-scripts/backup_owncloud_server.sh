#!/bin/sh

# makes a backup of the owncloud server on the raspberry pi
#
# taken from
# https://doc.owncloud.org/server/9.1/admin_manual/maintenance/backup.html
#
# author: langenhagen

echo "Really?"
echo "<ctrl+c> to escape or enter to proceed"
read THROW_AWAY_VAR

echo "`date`   Starting Owncloud backup"

OWNCLOUD_BACKUPDIR="/home/pi/stuff/owncloud-backup"
mkdir -p $OWNCLOUD_BACKUPDIR

cd /var/www/owncloud/
sudo rsync -Aax config data $OWNCLOUD_BACKUPDIR
echo "`date`   Sync of config/ and data/ complete"

DB_BACKUP_FILE_NAME="$OWNCLOUD_BACKUPDIR/owncloud-db-backup_`date +"%Y%m%d"`.bak"

sudo rm -f $DB_BACKUP_FILE_NAME
echo "`date`   Removal of old database dump complete"

# mariadb backup (!sic -p for password there is no space between -p and the password!)
sudo mysqldump --single-transaction -h localhost -u root -pca3MARIADB7c65 owncloud > $DB_BACKUP_FILE_NAME

# sqlite backup
# sqlite3 data/owncloud.db .dump > $DB_BACKUP_FILE_NAME
echo "`date`   Database dump complete"
