#!/bin/bash

# RICK stands for Remove **/*.I and **./*.Cxx files (which is now done by the cmake script), run cmaKe and build sdljni
# still RICK \m/

source common.sh


cd /Users/langenha/code/olympia-prime/build


echo-head DOING THE RICK - do CMake and call ninja carlo_sdl_integration_tests ...
echo '>>>>>>>>>>> RICK CALLS THE CMAKE'
bash $SCRIPTS_DIR/the-cmake-script.sh

echo '>>>>>>>>>>> RICK DOES THE NINJA SDLJNI'
bash $SCRIPTS_DIR/build-integration-tests.sh


echo ''
echo RICK DONE.