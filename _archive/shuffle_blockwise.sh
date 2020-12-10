#!/bin/bash
# Shuffle a file by blocks of given number of lines, leave the order within each block intact and
# write the results to another file.
#
# Usage:
#   shuffle_blockwise.sh <FILE> [<blocksize>]
#
# Examples:
#   shuffle_blockwise.sh myfile.txt      # Shuffle myfile.txt by default blocksize of 5
#   shuffle_blockwise.sh myfile.txt  3   # Shuffle myfile.txt by blocksize of 3
#
# author: andreasl
file="$1"
blocksize=${2:-5}

awk -v n="$blocksize" '1; NR % n == 0 {print ""}' "$1" > "${file}_shuf_tmp_${blocksize}"

awk '
  BEGIN{srand(); n=rand()}
  {print n, NR, $0}
  !NF {n=rand()}
  END {if (NF) print n, NR+1, ""}' "${file}_shuf_tmp_${blocksize}" \
      | sort -nk1 -k2 \
      | cut -d' ' -f3- \
      > "${file}_shuf_${blocksize}"
sed -i '/^$/d' "${file}_shuf_${blocksize}"

rm "${file}_shuf_tmp_${blocksize}"
