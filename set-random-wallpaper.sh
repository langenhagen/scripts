#!/bin/bash
# Set a random wallpaper from a given folder.
# Might not work with cronjobs because gnome is a bitch.
#
# Usage:
#
#   set-random-wallpaper.sh <FOLDER-NAME>
#
# Example:
#
#   set-random-wallpaper.sh ~/Pictures
#
# author: andreasl

[ $# == 1 ] || { echo "Error: No folder specified"; exit 1; }

images_folder="$1"

# shellcheck disable=SC2156
images_str="$(find "$images_folder" -exec sh -c "file --brief --mime-type '{}' | grep -qs 'image' && echo '{}'" \;)"

mapfile -t images <<<"$images_str"
random_index="$(((RANDOM % ${#images[@]})))"
selected_image="${images[${random_index}]}"

now="$(date '+%Y-%m-%d--%H-%M-%S')"
printf '%s: Setting image %s as background.\n' "$now" "$selected_image"

gsettings set org.gnome.desktop.background picture-uri "file:///${selected_image}"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///${selected_image}"
