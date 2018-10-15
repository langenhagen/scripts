#!/bin/bash

# Calls dmenu
# and uses the selected item to open the item with xdg-open.
#
# author: andreasl
# version: 18-09-23

choices=(
    "Dropbox"
    "Administrative"
    "Administrative/user-names.txt"
    "Barn"
    "Dev"
    "Dev/scripts"
    "Media"
    "Media/Images/Fotos/Cam"
    "Media/Audio"
    "Thunderbird/thunderbird"
    "Work")

dmenu_result="$(printf '%s\n' "${choices[@]}" | dmenu -i -l 30)"  # -i: ignore case

if [ $? == 0 ] ; then
    xdg-open /home/barn/${dmenu_result}  # opens nautilus at given point
fi