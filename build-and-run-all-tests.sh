#!/bin/bash
source common.sh

echo-head 'The RATS script: build an run all tests'

echo-ok 'Building and running the unit tests...'
bash $SCRIPTS_DIR/build-and-run-unit-tests.sh --gtest_filter='*'

if [ $? != 0 ] ; then
    echo-error "Build-And-Run-Unit Tests failed! Aborting."
    exit 1
fi

echo
echo-ok 'Building and running the integration tests...'
bash $SCRIPTS_DIR/build-integration-tests.sh
bash $SCRIPTS_DIR/run-integration-tests.sh 'test'

echo
echo-ok 'Running the smoke tests....'
bash $SCRIPTS_DIR/run-smoke-tests.sh


echo
echo-ok 'RATS done.'