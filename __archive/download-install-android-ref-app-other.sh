#!/bin/bash
#
# Takes an Android device id or uses the first found device,
# determines the device's architecture,
# creates a temporary directory,
# downloads the according latest apk into this directory and installs it onto the device.
#
# TODO fetch and apk filename automatically, e.g. by reading the current apk name from some file.

set -x

if [ $# -ge 2 ]; then
    device_id=$1
else
    device_id=$(adb devices | awk 'FNR == 2 {print $1}')
fi

supported_ABIs=$(adb -s $device_id shell getprop ro.product.cpu.abilist)
if [[ $supported_ABIs == *"arm64-v8a"* ]]; then
    app_ABI="arm64"
elif [[ $supported_ABIs == *"armeabi-v7a"* ]]; then
    app_ABI="arm"
elif [[ $supported_ABIs == *"x86_64"* ]]; then
    app_ABI="x86"
elif [[ $supported_ABIs == *"x86"* ]]; then
    app_ABI="x86_32"
else
    echo "Device $device_id architecture not supported"
    exit 1
fi

tmp_dir=$(mktemp -d)
trap "rm -rf $tmp_dir" EXIT

pushd $tmp_dir
file_name="com.here.ivi.reference-0.0.1-debug.apk"
wget -c https://corenav.cci.in.here.com/job/sparta/job/sv/job/build/job/sv-android-${app_ABI}-clang5.0-release/lastSuccessfulBuild/s3/download/apps/android-reference/mobile/build/outputs/apk/debug/${file_name}
adb -s $device_id install -d -r -t $file_name
if [ $? -ne 0 ]; then
    # sometimes, normal reinstall does not work. Then, uninstalling and installing
    # is a solution, but it also removes the configurations
    adb -s $device_id uninstall "com.here.ivi.reference.debug"
    adb -s $device_id install -d -t $file_name
fi
popd
