#!/usr/bin/env bash
# Split a video/audio file into many based on a separate timestamps list.
#
#   Usage: ./split-media-file.sh input.webm timestamps.txt
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
print_help() {
    cat <<'EOF'
Usage: split-media-file.sh [OPTIONS] <input-file> <timestamps-file>

Split a media file into multiple chapter files using timestamps.

Options:
  -h, --help  Show this help message and exit

Timestamps file format:
  0:00 - Introduction
  1:23 - Chapter 1
  34:56 - Chapter 2
  1:02:34 - The rest of the file
EOF
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
    exit 0
fi

if [[ $# -ne 2 ]]; then
    print_help >&2
    exit 1
fi

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

    line="${lines[i]}"
    start_time="${line%% - *}"
    title="${line#* - }"

    # Check next line for end timestamp
    if ((i + 1 < ${#lines[@]})); then
        next_line="${lines[i + 1]}"
        next_start_time="${next_line%% - *}"
        ffmpeg \
            -hide_banner \
            -nostdin \
            -i "$input_file" \
            -ss "$start_time" \
            -to "$next_start_time" \
            -c copy \
            -vn ${out_fmt:+-f "$out_fmt"} \
            "${num}_${title}.${out_ext}"
    else
        ffmpeg \
            -hide_banner \
            -nostdin \
            -i "$input_file" \
            -ss "$start_time" \
            -c copy \
            -vn ${out_fmt:+-f "$out_fmt"} \
            "${num}_${title}.${out_ext}"
    fi
done
