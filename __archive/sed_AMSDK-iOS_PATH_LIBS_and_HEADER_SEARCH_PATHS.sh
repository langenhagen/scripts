# sets the path libs in AMSDK-iOS

amsdk_ios_root_dir=~/code/AMSDK-iOS

sed -i -e 's#//PATH_LIBS = $(DEBUG_HCVD_LIBS)#PATH_LIBS = $(DEBUG_HCVD_LIBS)#g' $amsdk_ios_root_dir/Configurations/OEM/Olympia.xcconfig
sed -i -e 's#PATH_LIBS = $(PATH_TO_HCVD_LIBS)#//PATH_LIBS = $(PATH_TO_HCVD_LIBS)#g' $amsdk_ios_root_dir/Configurations/OEM/Olympia.xcconfig
sed -i -e 's#//HEADER_SEARCH_PATHS = $(DEBUG_HCVD_HEADERS)#HEADER_SEARCH_PATHS = $(DEBUG_HCVD_HEADERS)#g' $amsdk_ios_root_dir/Configurations/OEM/Olympia.xcconfig
sed -i -e 's#HEADER_SEARCH_PATHS = $(PATH_TO_HCVD_HEADERS)#//HEADER_SEARCH_PATHS = $(PATH_TO_HCVD_HEADERS)#g' $amsdk_ios_root_dir/Configurations/OEM/Olympia.xcconfig
