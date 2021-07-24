#!/bin/bash
# Remove the latin audio track from teh given mkv files. Requires `mkvmerge`.
#
# Usage:
#
#   bash remove-latin-audiotrack-from-mkvs.sh
#
# author: andreasl

mkdir -p out

for file in "$@"; do
    printf "$file\n"
    mkvmerge -o "out/$file" -a '!lat' "$file"
done
