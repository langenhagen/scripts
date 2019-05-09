#!/bin/bash
#
# Downloads an apk file from the web and
# installs it on the first attached Android device.
#
# TODO fetch and filenames automatically, e.g. by reading the current apk name from some file.

file_name="com.here.ivi.reference-0.0.1-debug.apk"

rm -f $file_name
wget https://corenav.cci.in.here.com/job/sparta/job/sv/job/build/job/sv-android-arm64-clang5.0-release/lastSuccessfulBuild/s3/download/apps/android-reference/mobile/build/outputs/apk/debug/$file_name

device_id=`adb devices | awk 'FNR == 2 {print $1}'`
adb -s $device_id install -r $file_name
if [ $? != 0 ] ; then
    # sometimes, normal reinstall does not work, then, it seems, uninstalling completely and
    # installing fresh is a solution, but it removes the config settings.
    adb -s $device_id uninstall "com.here.ivi.reference.debug"
    adb -s $device_id install $file_name
fi
