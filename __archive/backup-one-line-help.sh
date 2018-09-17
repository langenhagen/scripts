#!/bin/sh

# Appends the one-line-help file contents to an archive file,
# sorts the lines there
# and removes duplicate entries from that archive file.
#
# It is supposed to run as a cronjob, thus the paths to the programs are fully qualified.
#
# author: andreasl
# version 180828

input_file="/Users/langenha/stuff/one-line-helps/one-line-help-langenha-4demlangenha.txt"
backup_file="/Users/langenha/personal/Dev/Zeugs/one-line-helps/one-line-help-langenha-4demlangenha-archive.txt"

/bin/cat $input_file >> $backup_file

# -u: unique -o: output, also to same file (not possible with > stream operator)
/usr/bin/sort -u -o $backup_file $backup_file
