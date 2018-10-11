#!/bin/bash

# Calls dmenu with a bunch of options
# and uses the selected option to open a folder with  nautilus.
#
# author: andreasl
# version: 18-09-23

choices=(
    "Dropbox"
    "Administrative"
    "Barn"
    "Dev"
    "Dev/scripts"
    "Media"
    "Media/Images/Fotos/Cam"
    "Media/Audio"
    "Work")

dmenu_result="$(printf '%s\n' "${choices[@]}" | dmenu -i -l 30)"  # -i: ignore case

if [ $? == 0 ] ; then
    nautilus /home/barn/${dmenu_result}  # opens nautilus at given point
fi
