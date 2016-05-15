#!/bin/bash

#export MY_CURRENT_PATH=`pwd`
#cd $MY_CURRENT_PATH

source common.sh

echo-head PLAYGROUND.SH

cd ~/code/olympia-prime/build/
echo `pwd`


echo $@
echo ''

echo-error test dies ist
echo-ok der bestanden ist
echo-warn oder "was"

echo "????"
echo-ok ✔