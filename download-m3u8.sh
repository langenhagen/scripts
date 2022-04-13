#!/bin/bash
# Download an m3u8 file as a *.mkv file.
#
# Usage:
#
#   download-m3u8.sh <URL> [<OUT-FILE>]
#
# author: andreasl

m3u8_url="$1"
out_file="${2-stream.mkv}"

time ffmpeg -i "$m3u8_url" -c copy "$out_file"
