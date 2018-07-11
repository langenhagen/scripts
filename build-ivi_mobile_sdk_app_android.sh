#!/bin/bash
touch ~/code/sparta/corenav/sdk/common/src/main/cpp/core/Location.cpp
cd /Users/langenha/code/sparta/build/build-android-21-arm64-v8a
start_time=`date +%s`
ninja ivi_mobile_sdk_app_android
if [ $? != 0 ] ; then
    exit
fi
end_time=`date +%s`
duration=`expr $end_time - $start_time`
printf "`date +%s`  `date`\t\t$duration\n" >> ~/stuff/android-configure-times-from-ninja.txt