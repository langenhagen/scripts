#!/bin/bash
#
# Compare file trees in a readable format using rsync.
#
# Usage:
#   compare-file-trees.sh [OPTIONS] <dir1> <dir2>
#
# TODO finish doc
#  -1, --in-1
#  -2, --in-2
#  -d --only-different: only different files
#  -e --exclude: exclude can be many
#  -s --only-same:  only same files
#
# author: andreasl

# parse command line arguments
excludes=
must_be_in_1=false
must_be_in_2=false
only_different=false
only_same=false
source_dir=.
target_dir=.
while [ "$#" -gt '0' ] ; do
    case "$1" in
    -1|--in-1)
        must_be_in_1=true
        ;;
    -2|--in-2)
        must_be_in_2=true
        ;;
    -d|--only-different)
        only_different=true
        ;;
    -e|--exclude)
        excludes+="--exclude ${2} "
        shift
        ;;
    -s|--only-same)
        only_same=true
        ;;
    *) # unknown option
        source_dir="$1"
        shift
        target_dir="$1"
        ;;
    esac
    shift # past argument or value
done

# run rsync
# --delete also report files which are not in the source dir
# -a compare all metadata of file like timestamp and attributes
# -i print one line of information per file
# -n do not actually copy or delete
#rsync_output="$(rsync --delete -a -i -n "${1}/" "${2}/")" # TODO excludes
rsync_output="$(rsync --delete -a -i -n \
    ${excludes} \
    "${source_dir}/" "${target_dir}/")"

# postprocess the output from rsync
output="$(awk '{
if ($1 == ">f+++++++++" || $1 == "cd+++++++++") $1 = "1  ";
else if ($1 == "*deleting") $1 = "  2";
else $1= "1 2";
print $0;
}' <<< "$rsync_output")"

if [ "$only_same" == 'true' ]; then
    # filter out files that are different
    output="$(sed -E '/^1  |^  2/d' <<< "$output")"
elif [ "$only_different" == 'true' ]; then
    # filter out files that are in both
    output="$(sed '/^1 2/d' <<< "$output")"
fi

if [ "$must_be_in_1" == 'true' ]; then
    # filter lines that are not in 1
    output="$(sed '/^ /d' <<< "$output")"
fi
if [ "$must_be_in_2" == 'true' ]; then
    # filter lines that are not in 2
    output="$(sed '/^.. /d' <<< "$output")"
fi
printf '%s\n' "$output"
