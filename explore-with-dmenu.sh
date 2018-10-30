#!/bin/bash

# Calls dmenu on the given array of choices.
# If the selected choice is a folder, recursively open dmenu with the folder's contents as choices.
# If the selection is not a folder, attempt to open it with xdg-open.
# It can also open the terminal program `konsole` at the given path.
# Can handle symlinks.
#
# author: andreasl
# version: 18-10-30

selected_path="${HOME}"

choices=(
    'Dropbox'
    'Administrative'
    'Barn'
    'Dev'
    'Media'
    'Media/Images/Fotos/Cam'
    'Media/Audio'
    'Work')

while : ; do

    dmenu_result="$(printf '%s\n' "${choices[@]}" | dmenu -i -l 100)"  # -i: ignore case
    if [ $? != 0 ] ; then
        exit 1
    fi

    if [ "${dmenu_result}" = '<open terminal here>' ]; then
        konsole --workdir "${selected_path}"
        exit 0
    fi

    selected_path="$(realpath "${selected_path}/${dmenu_result}")"

    if [ -f "${selected_path}" -o "${dmenu_result}" = "." ]; then
        xdg-open "${selected_path}"
        exit 0
    elif [ -d "${selected_path}" ]; then
        choices=( '<open terminal here>' '.' '..' "$(ls -t "${selected_path}")")
    fi

done
