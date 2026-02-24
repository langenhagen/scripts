#!/usr/bin/env -S bash -ex

# Requires a running docker daemon

# TODO check if docker is already running

#open -a /Applications/Docker.app
#osascript -e 'quit app "docker"'
# ensure that docker is running


cd $ACS_MAIN_DIR/sdk_extensions/
docker run -t --rm -v `pwd`/../..:/workspace --user bldadmin \
           docker.release.in.here.com:5000/auto-core-sdk.u14-x86_32:latest \
           /bin/bash -c "cd /workspace/auto-core-sdk/sdk_extensions && ./scripts/check-style.sh"


# TODO quit docker if it was not running before...
#osascript -e 'quit app "docker"'