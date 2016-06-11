#!/bin/bash
source common.sh


echo-head RIT Running Integration Tests
cd ~/code/olympia-prime/build/
echo `pwd`


# check for libgls.dylib alias
if [ ! -f libgls.dylib ]; then
    echo-error ERROR
    echo-error `pwd`"/libgls.dylib alias not found"
    echo RIT SCRIPT EXITS
    exit 1
else
    echo '*** alias for libgls.dylib found ***'
fi

# set variables
WILDCARD=$1
IS_LOG_TO_STD_OUT=$2


if [ "$WILDCARD" = "" ]; then
    WILDCARD=testlocsync.*
fi
if [ "$IS_LOG_TO_STD_OUT" != "" ]; then
    IS_LOG_TO_STD_OUT=--log-to-stdout
fi


echo
echo Wildcard: $WILDCARD
echo Additional: $IS_LOG_TO_STD_OUT
echo


# do the integration tests
auto-core-sdk/sdk_extensions/tests/integration/runner/carlo_sdl_integration_tests \
../auto-core-sdk/sdk_extensions/tests/integration/test.py $WILDCARD $IS_LOG_TO_STD_OUT