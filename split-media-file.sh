#!/usr/bin/env bash
# Split a video/audio file into many based on a separate timestamps list.
#
#   Usage: ./split-file.sh input.webm timestamps.txt
#
# The timestamps file should have following format:
#
#   0:00 - Introduction
#   1:23 - Chapter 1
#   34:56 - Chapter 2
#   1:02:34 - The rest of the file
#   [...]
#
# author: andreasl
input_file="$1"
timestamps_file="$2"

# Detect audio codec
codec=$(ffprobe \
    -v error \
    -select_streams a:0 \
    -show_entries stream=codec_name \
    -of default=noprint_wrappers=1:nokey=1 \
    "$input_file")

# Map codec to container/extension
case "$codec" in
  opus)   out_ext="opus";  out_fmt="opus" ;;
  aac)    out_ext="m4a";   out_fmt="ipod" ;;
  mp3)    out_ext="mp3";   out_fmt="mp3"  ;;
  vorbis) out_ext="ogg";   out_fmt="ogg"  ;;
  *)      out_ext="audio"; out_fmt=""     ;;
esac

mapfile -t lines <"$timestamps_file"

for ((i = 0; i < ${#lines[@]}; i++)); do
    printf -v num "%04d" $((i + 1))

    IFS=" - " read -r start title <<<"${lines[i]}"

    # Check next line for end timestamp
    if ((i + 1 < ${#lines[@]})); then
        IFS=" - " read -r next_start _ <<<"${lines[i + 1]}"
        ffmpeg \
            -hide_banner \
            -nostdin \
            -i "$input_file" \
            -ss "$start" \
            -to "$next_start" \
            -c copy \
            -vn ${out_fmt:+-f "$out_fmt"} \
            "${num}_${title}.${out_ext}"
    else
        ffmpeg \
            -hide_banner \
            -nostdin \
            -i "$input_file" \
            -ss "$start" \
            -c copy \
            -vn ${out_fmt:+-f "$out_fmt"} \
            "${num}_${title}.${out_ext}"
    fi
done
