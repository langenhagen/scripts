#!/bin/bash
source ~/common.sh

echo-head 'The RATS script: build an run all tests'


### INPUT VARS

FAST_FAIL=false
if echo $* | grep -we '-fast' -q
then
    echo 'Argument -fast provided: Aborting on first test fail'
    FAST_FAIL=true
fi


### PROGRAM VARS

GOOGLETEST_ARGUMENTS=--gtest_filter='*'
if [ $FAST_FAIL = true ] ; then
    GOOGLETEST_ARGUMENTS="$GOOGLETEST_ARGUMENTS --gtest_break_on_failure"
fi


### PROGRAM

echo
echo-ok 'Building and running the unit tests...'
bash $SCRIPTS_DIR/build-and-run-unit-tests.sh $GOOGLETEST_ARGUMENTS
if [ $? != 0 ] ; then
    echo-error 'Build-And-Run-Unit Tests failed! Aborting.'
    exit 1
fi


echo
echo-ok 'Building integration tests...'
bash $SCRIPTS_DIR/build-integration-tests.sh
if [ $? != 0 ] ; then
    echo-error 'Building Integration Tests failed! Aborting.'
    exit 2
fi


echo
echo-ok 'Running integration tests...'
bash $SCRIPTS_DIR/run-integration-tests.sh 'test'


echo
echo-ok 'Running the smoke tests....'
bash $SCRIPTS_DIR/run-smoke-tests.sh


echo
echo-ok 'RATS done.'