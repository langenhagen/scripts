#!/bin/bash

echo "semiscript!"
exit 0


# AMSKD iOS
cd /Users/langenha/code/AMSDK-iOS
git pull origin staging
cd External/hcvd
bash ./scripts/hcvd-xcode.sh

# in xcode: link deps on AMSDKs.xcodeproj / Build Phases Tab / Target Dependencies
#     add:    carlo_sdl_module
#             carlo_olympia_module
#             watchdog
# open file   AMSDKs.xcodeproj / Configurations / OEM / Olympia.xconfig

# un-comment  PATH_LIBS = $(DEBUG_HCVD_LIBS)
#             HEADER_SEARCH_PATHS = $(DEBUG_HCVD_HEADERS)
# comment its counterparts
sed -i -e 's#//PATH_LIBS = $(DEBUG_HCVD_LIBS)#PATH_LIBS = $(DEBUG_HCVD_LIBS)#g' /Users/langenha/code/AMSDK-iOS/Configurations/OEM/Olympia.xcconfig
sed -i -e 's#PATH_LIBS = $(PATH_TO_HCVD_LIBS)#//PATH_LIBS = $(PATH_TO_HCVD_LIBS)#g' /Users/langenha/code/AMSDK-iOS/Configurations/OEM/Olympia.xcconfig

sed -i -e 's#//HEADER_SEARCH_PATHS = $(DEBUG_HCVD_HEADERS)#HEADER_SEARCH_PATHS = $(DEBUG_HCVD_HEADERS)#g' /Users/langenha/code/AMSDK-iOS/Configurations/OEM/Olympia.xcconfig
sed -i -e 's#HEADER_SEARCH_PATHS = $(PATH_TO_HCVD_HEADERS)#//HEADER_SEARCH_PATHS = $(PATH_TO_HCVD_HEADERS)#g' /Users/langenha/code/AMSDK-iOS/Configurations/OEM/Olympia.xcconfig

# Places DemoApp
cd /Users/langenha/code/AmsDemo1

git reset --hard HEAD
git pull --rebase

# Routes DemoApp
cd /Users/langenha/code/AmsDemo2

git reset --hard HEAD
git pull --rebase

# copy, but don't override existing 'secret' configuration file (-n)
cp -n /Users/langenha/stuff/ADAConfiguration.h /Users/langenha/code/AmsDemo2/AMS\ Sample\ Routes/


# open Demo Project
# Remove AMSKit

# Drag Drop amsdk.xcodeproj and the AMSDK-iOS/AudiLogin/MyAudiAuthenticator.xcodeprojfile
# into xcode into either of Your Demo Apps.
#
# In the Project file  / Build Phases / Target Dependencies
# add AMSKit
# add MyAudiAuthenticator   (in the Places app for MyAudiLoginBranch)
# No need to add  the NMAKit

# In the Sample Places / Build Phases / General / Embedded Binaries
# NMAKit.framework
# add MyAudiAuthenticator   (in the Places app for MyAudiLoginBranch)

# ----------------------------------------------------------------------------------------
# this might be the same as the preceeding step:

# into the ./Frameworks/ directory
# Please add the following frameworks to this directory:
# - NMAKit.framework
# - AMSKit.framework

# Links to these files come with the latest Release Mails to the AMSSDK for iOS. You can find them here:
#     http://cijenkins01.rnd.in.here.com:8080/job/Shoome/view/Comp/view/CompSDK/job/Companion-iOS-AMSKit-Release/
# alternativeliy, take the most recent one from here:
#     http://cijenkins01.rnd.in.here.com:8080/job/Shoome/view/Comp/view/CompSDK/job/Companion-iOS-AMSKit-Gerrit/

# ----------------------------------------------------------------------------------------

# Something Antonio told me (to be verified, maybe jibjab):
# delete all and build again
