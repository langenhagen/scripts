#!/bin/bash
source common.sh

echo-head RMAKE

BUILD_FOLDER=/Users/langenha/code/olympia-prime/build

# grep -w looks for whole words,
#      -e looks for beginning cuts at '-'s
#         - order important,
#      -q stands for quiet
if echo $* | grep -we '--new' -q
then
    echo 'Argument --new provided: resetting build folder'

    echo 'Backing up build folder...'
    cp -r $BUILD_FOLDER $BUILD_FOLDER"_bak-"$(date +%Y%m%d-%H%M%S)
    echo 'Removing old build folder...'
    rm -r $BUILD_FOLDER
    echo 'Creating new build folder...'
    mkdir $BUILD_FOLDER
fi

cd $BUILD_FOLDER
echo `pwd`
echo


rm -f **/*.i
rm -f **/*.cxx

cmake -GNinja -Wno-dev -DCMAKE_USE_CCACHE=1 -DADDRESS_SANITIZER=0 -DMONITOR_QUERY_EXECUTION=0 -DMOS_SHARED=0 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=installdir -DNO_QT=1 -DXMLSEC_CRYPTO_OPENSSL=0 -DWITH_DBUS=0 ..


echo
echo 'RMAKE DONE.'