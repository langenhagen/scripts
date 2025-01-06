#!/bin/bash
# From the given image file create a 3x3 tiling image and open it to inspect it.
#
# author: andreasl
set -x
input_file="$1"
extension="${input_file##*.}"
out_filename="$(mktemp -u)_tiling.${extension}"

montage -tile 3x3 -geometry +0+0 \
    "$input_file" "$input_file" "$input_file" \
    "$input_file" "$input_file" "$input_file" \
    "$input_file" "$input_file" "$input_file" \
    "$out_filename"

feh "$out_filename"
