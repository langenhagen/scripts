#!/bin/bash
# Echo the given input
# and send the input as a string as a push notification via pushover.
#
# author: andreasl

function pushover() {
    # echo the given input
    # and send the input as a string as a push notification via pushover.
    pushover_app_token=agna4fob6wu7e7t2ofhz1drt7ptngq  # change according to app/platform
    pushover_user_token=ucw67xi5r5mqgqo8arh3p64xkj39wu

    echo "pushover: $*"
    curl --silent \
         --form-string "token=$pushover_app_token" \
         --form-string "user=$pushover_user_token" \
         --form-string "message=$*" \
         https://api.pushover.net/1/messages.json
 }
