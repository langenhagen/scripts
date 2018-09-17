#!/bin/sh/ -x

# Backs up owncloud user files  directory with rsync
# writes a log
# sends pushover notification on error
#
# author: langenhagen
# version: 170507

NOW="$(date +'%Y-%m-%d--%H-%M-%S')"

INFO_FILE=/home/pi/last_monthly_backup_from.txt
echo "The last rsnapshot backup started at " > $INFO_FILE
echo "" >> $INFO_FILE
echo "$(date)" >> $INFO_FILE

LOG_DIR=/home/pi/rsnapshot_logs
mkdir -p $LOG_DIR
FILENAME="$LOG_DIR/backup_monthly_$NOW.log"

echo "Backup starts at $NOW" > $FILENAME

# -v:verbose; -V: very verbose
sudo rsnapshot -v monthly >> $FILENAME

rsnapshot_return_code=$?
if [ rsnapshot_return_code == 1 ]; then
    /usr/bin/curl -s \
                  --form-string "token=anjdhkj51igvgxiwmkmg9i1iiioczd" \
                  --form-string "user=ucw67xi5r5mqgqo8arh3p64xkj39wu" \
                  --form-string "message=rsnapshot encountered an error on monthly backup!" \
                  https://api.pushover.net/1/messages.json
fi


NOW="$(date +'%Y-%m-%d--%H-%M-%S')"
echo "Backup ends at $NOW" >> $FILENAME
echo "EOF" >> $FILENAME
