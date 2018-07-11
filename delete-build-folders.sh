#!/bin/bash

# Given a build folder,
# deletes the distributed sparta build folders given a certain impact level.
#
# author: andreasl
# version: 18-06-24

# if [ $# != 1 ] ; then
#     printf "Usage:\n\t$0 <BUILD-PATH>\n\nExample:\n\t$0 path/to/build/folder\n\n"
#     exit
# fi

echo "Delete..."
echo "(1) delete MINI: sdk's and apps {build, jniLibs, libs} folder contents"
echo "(2) delete SMALL:  <BUILD-PATH>/corenav/sdk; sdk's and apps {build, jniLibs, libs} folder contents"
echo "(3) delete ALL: <BUILD-PATH>; sdk's and apps {build, jniLibs, libs} folder contents"
echo "(4) delete <BUILD-PATH>/preinstall-image; sdk's and apps {build, jniLibs, libs} folder contents"
read -p "Your choice?: " impact_level

# compile the folders that are to be deleted
build_and_lib_dirs=(
    "/Users/langenha/code/sparta/apps/android-reference"
    "/Users/langenha/code/sparta/corenav/sdk"
    )
additional_dirs=( )

if [ $impact_level == 1 ] ; then
    : # noop
elif [ $impact_level == 2 ] ; then
    additional_dirs+=("$1/corenav/sdk")
elif [ $impact_level == 3 ] ; then
    additional_dirs+=("$1")
elif [ $impact_level == 4 ] ; then
    additional_dirs+=("$1/preinstall-image")
else
    echo "I do not know the option $impact_level lol bye!"
    exit
fi

# store choice into this script file for later statistics
script_path=${BASH_SOURCE[0]}
line=`grep "option $impact_level: " "$script_path"`
current_count=`echo $line | awk '{print $NF}'`
new_count=`expr $current_count + 1`
new_line=`echo $line | awk -v nc="$new_count" '{$NF = nc; print}'`
sed -i "s/$line/$new_line/" "$script_path"

# # each chooce has been taken
# Number of runs on with option 1: 115
# Number of runs on with option 2: 11
# Number of runs on with option 3: 7
# Number of runs on with option 4: 33

# do the delete process
set -x
for dir in ${additional_dirs[@]} ; do
    rm -rf $dir
done
for dir in ${build_and_lib_dirs[@]} ; do
    find $dir -regex ".*/build/.*" -exec rm -rf '{}' \;
    find $dir -regex ".*/libs/.*" -not -path "*/\.keepme" -exec rm -fd '{}' \;  # rm -fd: don't kill non-empty dirs
    find $dir -regex ".*/jniLibs/.*" -exec rm -rf '{}' \;
done
