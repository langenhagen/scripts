#!/bin/bash

# A word about obstruct grep statements:
#
# grep -w looks for whole words,
#      -e looks for beginning cuts at '-'s
#         - order important,
#      -q stands for quiet

source ~/common.sh
echo-head 'RMAKE'

echo "Olymp Build Dir: $ACS_BUILD_DIR"
echo "Olymp Main Dir:   $ACS_MAIN_DIR/.."

### INPUT VARS #####################################################################################

BACKUP_AND_RESET_BUILD_FOLDER=false
if echo $* | grep -we '--new' -q ; then BACKUP_AND_RESET_BUILD_FOLDER=true; fi

NO_BACKUP_AND_RESET_BUILD_FOLDER=false
if echo $* | grep -we '--allnew' -q ; then NO_BACKUP_AND_RESET_BUILD_FOLDER=true; fi

### PROGRAM VARS ###################################################################################

BACKUP_BUILD_FOLDER=false
if [ $BACKUP_AND_RESET_BUILD_FOLDER = true ] ; then
    BACKUP_BUILD_FOLDER=true
fi

RESET_BUILD_FOLDER=false
if [ $BACKUP_AND_RESET_BUILD_FOLDER = true ] || [ $NO_BACKUP_AND_RESET_BUILD_FOLDER = true ] ; then
    RESET_BUILD_FOLDER=true
fi

### PROGRAM ########################################################################################

mkdir -p $ACS_BUILD_DIR

if [ $BACKUP_BUILD_FOLDER = true ] ; then
    echo 'Backing up build folder...'
    cp -r $ACS_BUILD_DIR $ACS_BUILD_DIR"_bak-"$(date +%Y%m%d-%H%M%S)
fi

if [ $RESET_BUILD_FOLDER = true ] ; then
    echo 'Removing old build folder...'
    rm -r $ACS_BUILD_DIR
    echo 'Re-creating new build folder...'
    mkdir $ACS_BUILD_DIR
fi


cd $ACS_BUILD_DIR
rm -f **/*.i
rm -f **/*.cxx


if [ "$ACS_ENVIRONMENT" = "ACS Xcode Xcode" ] ; then
    echo ' ACS Environment is Xcode with Xcode build system. Using the Xcode build script from the repo...'
    cd $ACS_MAIN_DIR/../..
    bash ./scripts/hcvd-xcode.sh
elif [ "$ACS_ENVIRONMENT" = "ACS Xcode Ninja" ] ; then
    echo ' ACS Environment is Xcode with Ninja build system. Using the Xcode build script from the repo...'
    cd $ACS_MAIN_DIR/../..
    bash ./scripts/hcvd-ninja.sh
else
    echo "Normal Ninja Case"
    cmake -GNinja -Wno-dev \
        -DCMAKE_USE_CCACHE=1 \
        -DADDRESS_SANITIZER=0 \
        -DMONITOR_QUERY_EXECUTION=0 \
        -DMOS_SHARED=0 \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_INSTALL_PREFIX=installdir \
        -DNO_QT=1 \
        -DXMLSEC_CRYPTO_OPENSSL=0 \
        -DWITH_DBUS=0 \
        $ACS_MAIN_DIR/..
fi

echo
echo 'linking a valid libgls.dylib alias into build dir (although their sources may not yet exit) ...'      # we do both just bc the code would be more complex otherwise :)
ln -sf $ACS_BUILD_DIR/auto-core-sdk/locationsdk/samples/positioning/glsempty/libgls.dylib $ACS_BUILD_DIR    # Mac X
ln -sf $ACS_BUILD_DIR/auto-core-sdk/locationsdk/samples/positioning/glsempty/libgls.so $ACS_BUILD_DIR       # Linux

echo
echo 'RMAKE DONE.'
