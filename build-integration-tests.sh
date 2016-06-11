#!/bin/bash

source common.sh


cd /Users/langenha/code/olympia-prime/build


echo-head 'building carlo_sdl_integration_tests...'
echo `pwd`
echo

ninja carlo_sdl_integration_tests


echo
echo 'linking a valid libgls.dylib alias into olympia build dir...'
ln /Users/langenha/code/olympia-prime/build/auto-core-sdk/locationsdk/samples/positioning/glsempty/libgls.dylib /Users/langenha/code/olympia-prime/build/

echo 'BUILDING carlo_sdl_integration_tests DONE.'