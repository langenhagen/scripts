#!/bin/bash
# Download an m3u8 file as a *.m4v file.
#
# Usage:
#
#   download-m3u8.sh <URL> [<OUT-FILE>]
#
# author: andreasl

m3u8_url="$1"
out_file="${2-stream.m4v}"


[ "${out_file%.*}" == "$out_file" ] && out_file="${out_file}.m4v"

time ffmpeg -i "$m3u8_url" -c copy "$out_file"
