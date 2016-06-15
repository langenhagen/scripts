#!/bin/bash

source common.sh


cd /Users/langenha/code/olympia-prime/build


echo-head 'building carlo_sdl_unit_tests...'
echo `pwd`
echo ''

ninja carlo_sdl_unit_tests

exit $?