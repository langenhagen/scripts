#!/bin/bash
source ~/common.sh

if [ "$1" == "" ] ; then
    echo-error 'ERROR: new-task needs a name for a new branch.'
    exit 1
fi

echo-head "Creating new Task named $1"


### INPUT VARS

DO_RATS=false
if [ "$2" == "rats" ] ; then
    echo 'Argument rats provided: Building and running the tests after branch creation'
    DO_RATS=true
fi


### PROGRAM

cd $OLYMPIA_MAIN_DIR/auto-core-sdk

git checkout staging                                                                                # go to staging
if [ $? != 0 ] ; then
    echo-error "ERROR: Cannot checkout staging. Have you committed your current changes? ;)"
    git branch
    exit 2
fi


git rev-parse --verify $1 &>/dev/null                                                               # check if branch already exists
if [ $? == 0 ] ; then
    echo-warn "ERROR: Branch $1 exists already."

    echo 'You want to create delete it? (y/n) '
    read -n 1 key
    echo

    if [ "$key" != "y" ] && [ "$key" != "Y" ] ; then
        echo-ok "You don't want to delete it. Aborting"
        exit 3
    fi

    git branch -D $1
fi

git branch $1

repo sync
git pull origin staging
git checkout $1


echo
echo '-----------------------------------------------'
git branch;
echo '-----------------------------------------------'


echo                                                                                                # run cmake
echo-ok 'Doing the CMake...'
bash $SCRIPTS_DIR/the-cmake-script.sh --allnew


                                                                                                    # run rats
if [ $DO_RATS == true ] ; then
    bash $SCRIPTS_DIR/build-and-run-all-tests.sh
fi


echo
echo '-----------------------------------------------'
git branch;
echo '-----------------------------------------------'

echo
echo-ok "New-Task done"