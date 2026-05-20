#!/usr/bin/env bash
# Count the lines of code in my directories under $HOME/Dev.
#
# Usage:
#
#   loc.sh
#
# author: andreasl

cloc "$HOME/Dev" --exclude-dir='Zeugs'
