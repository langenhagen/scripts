#!/bin/bash
source ~/common.sh

echo-head 'RMAKE'

mkdir -p $OLYMPIA_BUILD_DIR

# grep -w looks for whole words,
#      -e looks for beginning cuts at '-'s
#         - order important,
#      -q stands for quiet
if echo $* | grep -we '--new' -q
then
    echo 'Argument --new provided: resetting build folder'

    echo 'Backing up build folder...'
    cp -r $OLYMPIA_BUILD_DIR $OLYMPIA_BUILD_DIR"_bak-"$(date +%Y%m%d-%H%M%S)
    echo 'Removing old build folder...'
    rm -r $OLYMPIA_BUILD_DIR
    echo 'Creating new build folder...'
    mkdir $OLYMPIA_BUILD_DIR
fi


if echo $* | grep -we '--allnew' -q
then
    echo 'Argument --allnew provided: resetting build folder without backup'

    echo 'Removing old build folder...'
    rm -r $OLYMPIA_BUILD_DIR
    echo 'Creating new build folder...'
    mkdir $OLYMPIA_BUILD_DIR
fi



cd $OLYMPIA_BUILD_DIR
echo `pwd`
echo


rm -f **/*.i
rm -f **/*.cxx

cmake -GNinja -Wno-dev -DCMAKE_USE_CCACHE=1 -DADDRESS_SANITIZER=0 -DMONITOR_QUERY_EXECUTION=0 -DMOS_SHARED=0 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=installdir -DNO_QT=1 -DXMLSEC_CRYPTO_OPENSSL=0 -DWITH_DBUS=0 $OLYMPIA_MAIN_DIR



echo
echo 'linking a valid libgls.dylib alias into olympia build dir (although their sources do not yet exit) ...'      # we do both just bc the code yould be mor complex otherwise :)
ln -s $OLYMPIA_BUILD_DIR/auto-core-sdk/locationsdk/samples/positioning/glsempty/libgls.dylib $OLYMPIA_BUILD_DIR    # Mac X
ln -s $OLYMPIA_BUILD_DIR/auto-core-sdk/locationsdk/samples/positioning/glsempty/libgls.so $OLYMPIA_BUILD_DIR       # Linux

echo
echo 'RMAKE DONE.'
