#!/usr/bin/env bash

mkdir -p prime
cd prime
WORKSPACE=$(pwd)

# You likely don't need that if You are using Your repo sources
###################################################################################################
# if [ -z "$REPO_USER" ]; then
#     export REPO_USER="$USER"
# fi
#
# repo init \
#     -u ssh://${REPO_USER}@gerrit.it.here.com:29418/prime/manifest \
#     -m hcvd.xml
# repo sync -d -c -j2
###################################################################################################

echo "---- Building XCode project files ----"
cd $WORKSPACE
rm -rf build-xcode
mkdir build-xcode
cd build-xcode
cmake -GXcode \
             -Wno-dev \
             -DIOS=ON \
             -IOS_PLATFORM=OS \
             -DNO_QT=ON \
             -DIOS_BUILD_ALL_ARCH=ON \
	     -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON \
             -DCMAKE_USE_CCACHE=ON \
             -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchains/iOS.cmake \
             -DCMAKE_BUILD_TYPE=RelWithDebInfo \
             -DCMAKE_INSTALL_MESSAGE=NEVER \
             -DBUILD_CARLO_SDK_EXTENSIONS_TESTS=ON \
             -DBUILD_CARLO_SDK_EXTENSIONS_APPS=OFF \
             -DBUILD_CARLO_SDK_EXTENSIONS_EXAMPLES=OFF \
             -DBUILD_CARLO_NAVCORE_MODULE=OFF \
             -DBUILD_CARLO_NDSDM_MODULE=OFF \
             -DBUILD_CARLO_MG_MODULE=OFF \
             -DWITH_WERROR=OFF \
             -DLINK_STATIC_GLS_TARGET=glsempty \
             -DNO_JAVA=ON \
             -DSQLITE_ENABLE_SQLCIPHER=ON \
            $ACS_MAIN_DIR/..

echo "---- Postprocessing project ----"
sed -i '' -e '/SYMROOT = /d' "hcvd.xcodeproj/project.pbxproj"
# remove warnings that are not in our control
sed -i -e 's/-Wall//g' hcvd.xcodeproj/project.pbxproj
sed -i -e 's/\"-Wno-four-char-constants\"/\"-Wno-four-char-constants\",\"-Wno-unused-local-typedefs\",\"-Wno-tautological-undefined-compare\",\"-Wno-unused-private-field\"/g' hcvd.xcodeproj/project.pbxproj
sed -i -e 's/ENABLE_BITCODE = NO;/ENABLE_BITCODE = NO; GCC_WARN_64_TO_32_BIT_CONVERSION = NO;/g' hcvd.xcodeproj/project.pbxproj
