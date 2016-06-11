#!/bin/bash
source common.sh


# *** Takes the line argumens as gtest arguments ***

cd /Users/langenha/code/olympia-prime/build/auto-core-sdk/sdk_extensions/tests/unit



bash $SCRIPTS_DIR/build-unit-tests.sh

/Users/langenha/code/olympia-prime/build/auto-core-sdk/sdk_extensions/tests/unit/carlo_sdl_unit_tests $@