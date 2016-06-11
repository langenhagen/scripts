#!/bin/bash
source common.sh


cd ~/code/olympia-prime/build/


echo-head 'RST Running Smoke Tests'
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



# do the smoke tests
auto-core-sdk/sdk_extensions/tests/integration/runner/carlo_sdl_integration_tests \
../auto-core-sdk/sdk_extensions/tests/integration/test.py