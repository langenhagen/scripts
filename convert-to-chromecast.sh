#!/bin/bash
# Convert a video file to chromecast-compatible format.
#
# Usage:
#
#   convert-to-chromecast.sh <input-file> [<output-file>]
#
# author: andreasl

[ $# -lt 1 ] && { printf "Usage: ${0##*/} <input-file> [<output-file>]\n"; exit 1; }

in_file="$1"
out_file="${2-${in_file%.*}.m4v}"

time HandBrakeCLI --preset 'Chromecast 1080p60 Surround' --input "$in_file" --output "$out_file"
