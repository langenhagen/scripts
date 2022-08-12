#!/bin/bash
# Download a m3u8 indexfile that causes to download many .ts files
# and concatenate the .ts files to a single .ts file.
#
# Usage:
#
#   download-index-m3u8.sh <URL> <NAME>
#
# Examples:
#
#   download-index-m3u8.sh http://foo.bar/some.m3u8 my-movie
#
# author: andreasl

m3u8_url="$1"
movie="$2"

mkdir "$movie" || exit 1
cd "$movie" || exit 2

download-m3u8.sh "$m3u8_url" "index.m3u8"

cat $(ls -v *.ts) > "${movie}.ts"
