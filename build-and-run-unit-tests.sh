#!/bin/bash
source ~/common.sh

# *** Takes the line argumens as gtest arguments ***


bash $SCRIPTS_DIR/build-unit-tests.sh
if [ $? != 0 ] ; then
    echo-error "Building Unit Tests failed! Aborting."
    exit 1
fi


bash $SCRIPTS_DIR/run-unit-tests.sh $@
if [ $? != 0 ] ; then
    echo-error "GTest Unit Tests failed!"
    exit 2
fi