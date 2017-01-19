#!/bin/bash
source ~/common.sh


cd $ACS_BUILD_DIR


echo-head 'building carlo_sdl_integration_tests...'
echo `pwd`
echo

ninja carlo_sdl_integration_tests
BUILD_EXIT_CODE=$?
if [ $BUILD_EXIT_CODE != 0 ] ; then
    echo-error 'Building carlo_sdl_integration_tests FAILED!'
else
    echo-ok 'BUILDING carlo_sdl_integration_tests DONE.'
fi


exit $BUILD_EXIT_CODE