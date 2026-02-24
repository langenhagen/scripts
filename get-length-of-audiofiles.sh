#!/usr/bin/env bash
# Get the individual durations of audiofiles of several formats in a folder as well as their total
# duration.
#
# Usage:
#   get-length-of-audiofiles.sh                # get the duration of audiofiles inside the cwd
#   get-length-of-audiofiles.sh  ~/my/folder/  # get the duration of audiofiles inside given folder
#
# author: andreasl

total_seconds=0

for file in *.{aac,flac,m4a,mp3,ogg,opus,wav,wma}; do
  [ -e "$file" ] || continue  # skip if no matching files

  duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$file")
  seconds=${duration%.*}  # Convert to integer (remove decimals)
  total_seconds=$((total_seconds + seconds))
  printf "%s: %02d:%02d:%02d\n" "$file" $((seconds/3600)) $(((seconds%3600)/60)) $((seconds%60))
done

printf "Total duration: %02d:%02d:%02d\n" $((total_seconds/3600)) $(((total_seconds%3600)/60)) $((total_seconds%60))
