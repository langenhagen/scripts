#!/bin/bash

# Calls dmenu with a bunch of options
# and uses the selected option to open a folder with  nautilus.
#
# TODO: somehow use a key command to start this program from the environment.
#
# author: andreasl
# version: 18-09-23

dmenu_result="$(printf "Administrative\nBarn\nDev\nDropbox\nMedia\nWork" | dmenu -i)"  # -i: ignore case

nautilus /home/barn/${dmenu_result}  # opens nautilus at given point
