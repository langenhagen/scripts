#!/bin/bash

PUSHOVER_APP_TOKEN=agna4fob6wu7e7t2ofhz1drt7ptngq
PUSHOVER_USER_TOKEN=ucw67xi5r5mqgqo8arh3p64xkj39wu
SCRIPT_NAME=`basename "$0"`

MESSAGE=$@
if [ ! $MESSAGE ]
then
    MESSAGE=':*'
fi

echo "$SCRIPT_NAME:    $MESSAGE"


curl -s \
     --form-string "token=$PUSHOVER_APP_TOKEN" \
     --form-string "user=$PUSHOVER_USER_TOKEN" \
     --form-string "message=$MESSAGE" \
     https://api.pushover.net/1/messages.json \
     &> /dev/null


exit $?