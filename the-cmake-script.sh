#!/bin/bash
source common.sh

cd /Users/langenha/code/olympia-prime/build


echo-head RMAKE RUNNING IN
echo `pwd`
echo ""


rm -f **/*.i
rm -f **/*.cxx

cmake -GNinja -Wno-dev -DCMAKE_USE_CCACHE=1 -DADDRESS_SANITIZER=0 -DMONITOR_QUERY_EXECUTION=0 -DMOS_SHARED=0 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=installdir -DNO_QT=1 -DXMLSEC_CRYPTO_OPENSSL=0 -DWITH_DBUS=0 ..


echo ''
echo RMAKE DONE.