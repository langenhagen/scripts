#!/bin/bash

# Deletes superfluous storage-consuming directories and files.
#
# author: andreasl
# version: 18-06-22

set -x

rm -rfv ~/.gradle/caches
rm -rfv ~/.gradle/daemon  # TODO verify
rm -rfv ~/.m2/repository


find ~/code -iname '.gradle' -type d -exec rm -rfv '{}' \;

docker container prune --force