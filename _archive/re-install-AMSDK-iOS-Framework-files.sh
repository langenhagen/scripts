#/bin/bash
#
# author: langenhagen

# hopefully you have the *.framework files downloaded into the right folder :)
# download them and unzip them and put them into the right folder


DOWNLOAD_DIR = "/Users/langenha/Dropbox"
AMSDK_FRAMEWORKS_DIR = "/Users/langenha/code/AMSDK-iOS/Frameworks"
AMSDEMO1_FRAMEWORKS_DIR = "/Users/langenha/code/AmsDemo1/Frameworks"
AMSDEMO2_FRAMEWORKS_DIR = "/Users/langenha/code/AmsDemo2/Frameworks"


# remove old framework files
rm -rf $AMSDK_FRAMEWORKS_DIR/*.framework
rm -rf $AMSDEMO1_FRAMEWORKS_DIR/*.framework
rm -rf $AMSDEMO2_FRAMEWORKS_DIR/*.framework

# AMSDK-iOS
cp -R $DOWNLOAD_DIR/HereAccount.framework $AMSDK_FRAMEWORKS_DIR
cp -R $DOWNLOAD_DIR/NMAKit.framework $AMSDK_FRAMEWORKS_DIR

# AMSDemo1
cp -R $DOWNLOAD_DIR/HereAccount.framework $AMSDEMO1_FRAMEWORKS_DIR
cp -R $DOWNLOAD_DIR/AMSKit.framework $AMSDEMO1_FRAMEWORKS_DIR
cp -R $DOWNLOAD_DIR/NMAKit.framework $AMSDEMO1_FRAMEWORKS_DIR


# AMSDemo2
cp -R $DOWNLOAD_DIR/HereAccount.framework $AMSDEMO2_FRAMEWORKS_DIR
cp -R $DOWNLOAD_DIR/AMSKit.framework $AMSDEMO2_FRAMEWORKS_DIR
cp -R $DOWNLOAD_DIR/NMAKit.framework $AMSDEMO2_FRAMEWORKS_DIR


# Remove Frameworks from the Download Dir
rm -rf $DOWNLOAD_DIR/HereAccount.framework
rm -rf $DOWNLOAD_DIR/AMSKit.framework
rm -rf $DOWNLOAD_DIR/NMAKit.framework
