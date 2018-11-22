#!/bin/bash
#
# Archives important files andf folders that should not be copied via cloud.
#
# author: andreasl
# version: 18-11-14

tar czf "archived-user-files-$(whoami)--$(hostname).tar.gz" \
    "${HOME}/.thunderbird" \
    "${HOME}/.ssh"