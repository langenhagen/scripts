#!/bin/bash
# Shuffle a file by blocks of n=5 lines, leave the order within each block intact and
# write the results to another file.
#
# author: andreasl

awk -v n=5 '1; NR % n == 0 {print ""}' "$1" > "${1}_shuf_tmp"

awk '
  BEGIN{srand(); n=rand()}
  {print n, NR, $0}
  !NF {n=rand()}
  END {if (NF) print n, NR+1, ""}' "${1}_shuf_tmp" | sort -nk1 -k2 | cut -d' ' -f3- > "${1}_shuf"

rm "${1}_shuf_tmp"
sed -i '/^$/d' "${1}_shuf"
