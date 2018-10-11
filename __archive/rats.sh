#!/bin/bash
source ~/common.sh

echo-head 'The RATS script: build an run all tests'


### INPUT VARS #####################################################################################

FAST_FAIL=false
if echo $* | grep -we '-fast' -q
then
    echo 'Argument -fast provided: Aborting on first test fail'
    FAST_FAIL=true
fi


### PROGRAM VARS ###################################################################################

GOOGLETEST_ARGUMENTS=--gtest_filter='*'
if [ $FAST_FAIL = true ] ; then
    GOOGLETEST_ARGUMENTS="$GOOGLETEST_ARGUMENTS --gtest_break_on_failure"
fi


### PROGRAM ########################################################################################

cd $ACS_BUILD_DIR;

echo-ok 'Building Unit Tests...'
ninja carlo_sdl_unit_tests
if [ $? != 0 ] ; then
    echo-error 'Building Unit Tests failed! Aborting.'
    exit 1
fi

echo-ok 'Running Unit Tests...'
auto-core-sdk/sdk_extensions/tests/unit/carlo_sdl_unit_tests $GOOGLETEST_ARGUMENTS
if [ $? != 0 ] ; then
    echo-error 'Running Unit Tests failed! Aborting.'
    exit 2
fi

echo-ok 'Building Integration/Smoke Tests...'
ninja carlo_sdl_integration_tests
if [ $? != 0 ] ; then
    echo-error 'Building Integration Tests failed! Aborting.'
    exit 3
fi

echo-ok 'Running Integration Tests...'
auto-core-sdk/sdk_extensions/tests/integration/runner/carlo_sdl_integration_tests \
    $ACS_MAIN_DIR/sdk_extensions/tests/integration/test.py
if [ $? != 0 ] ; then
    echo-error 'Running Integration Tests failed! Aborting.'
    exit 4
fi

echo-ok 'Running Smoke Tests...'
auto-core-sdk/sdk_extensions/tests/integration/runner/carlo_sdl_integration_tests \
    $ACS_MAIN_DIR/sdk_extensions/tests/integration/smoke/test.py
if [ $? != 0 ] ; then
    echo-error 'Running Smoke Tests failed! Aborting.'
    exit 5
fi

echo-ok 'RATS done.'
exit 0