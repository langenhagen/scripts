#!/bin/bash
source ~/common.sh


cd $OLYMPIA_BUILD_DIR


auto-core-sdk/sdk_extensions/tests/unit/carlo_sdl_unit_tests $@
if [ $? != 0 ]; then
    exit 1
fi