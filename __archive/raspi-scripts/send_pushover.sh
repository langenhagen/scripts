#!/bin/sh

echo 'Sending Pushover'
/usr/bin/curl -s \
              --form-string "token=anjdhkj51igvgxiwmkmg9i1iiioczd" \
              --form-string "user=ucw67xi5r5mqgqo8arh3p64xkj39wu" \
              --form-string "message=Ping!" \
              https://api.pushover.net/1/messages.json

echo 'Sending Pushover Finished'
