#!/bin/bash
# Log when the screen is locked or unlocked on gnome 3.
# Works with screen locking (e.g. super + l) and going to hibernation.
#
# based on:
# https://unix.stackexchange.com/questions/28181/run-script-on-screen-lock-unlock

log_file_path="${HOME}/Administrative/logs/logins-$(uname -n)-$(date '+%Y').csv"

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" |
  while read x; do
    case "$x" in
      *"boolean true"*) printf "$(date),locked\n" >> "$log_file_path";;
      *"boolean false"*) printf "$(date)\n,unlocked" >> "$log_file_path";;
    esac
  done
