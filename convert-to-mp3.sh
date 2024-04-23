#!/bin/bash
# Convert every `.flac` file in the CWD to an mp3 file.
mkdir -p mp3

for file in *.flac; do
    ffmpeg -i "$file" -ar 48000 -acodec mp3 -ab 320k "mp3/${file%.flac}.mp3"
done
