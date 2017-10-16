#!/bin/sh

# Backs up the one-line-help file into an archive file sorts the lines
# and removes duplicate entries from that archive file.
#
# It is supposed to run as a cronjob, thus the paths to the programs are fully qualified.
#
# author: langenhagen
# version 170726

input_file="/Users/langenha/stuff/one-line-helps/one-line-help-langenha-4demlangenha.txt"
backup_file="/Users/langenha/personal/Dev/Zeugs/one-line-helps/one-line-help-langenha-4demlangenha-archive.txt"

/bin/cat $input_file >> $backup_file

# -u: unique -o: output, also to same file (not possible with > stream operator)
/usr/bin/sort -u -o $backup_file $backup_file
