#!/usr/bin/env bash
source ~/common.sh

### INPUT VARS #####################################################################################

BRANCH_NAME=$1
if [ "$BRANCH_NAME" == "" ]; then
    echo-error 'ERROR: new-task needs a name for a new branch.'
    exit 1
fi

DO_RATS=false
if [ "$2" == "rats" ]; then
    echo 'Argument rats provided: Building and running the tests after branch creation'
    DO_RATS=true
fi

### PROGRAM ########################################################################################

echo-head "Creating new Task named $BRANCH_NAME"

cd $ACS_MAIN_DIR

git checkout staging
if [ $? != 0 ]; then
    echo-error "ERROR: Cannot checkout staging. Have you committed your current changes? ;)"
    git branch
    exit 2
fi


git rev-parse --verify $BRANCH_NAME &>/dev/null
if [ $? == 0 ]; then
    echo-warn "ERROR: Branch $BRANCH_NAME exists already."

    echo 'You want to create delete it? (y/n) '
    read -n 1 key
    echo

    if [ "$key" != "y" ] && [ "$key" != "Y" ]; then
        echo-ok "You don't want to delete it. Aborting"
        exit 3
    fi

    git branch -D $BRANCH_NAME
fi

git branch $BRANCH_NAME

repo sync
git pull origin staging
git checkout $BRANCH_NAME


echo
echo '-----------------------------------------------'
git branch;
echo '-----------------------------------------------'


echo-ok 'Doing the CMake...'
bash $SCRIPTS_DIR/the-cmake-script.sh --allnew


if [ $DO_RATS == true ]; then
    echo-ok 'Doing the Rats...'
    bash $SCRIPTS_DIR/rats.sh
fi


echo
echo '-----------------------------------------------'
git branch;
echo '-----------------------------------------------'

echo
echo-ok "New-Task done."