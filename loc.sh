#!/bin/bash
# Count the lines of code in my directories und $HOME/Dev.
#
# author: andreasl

cloc "$HOME/Dev" --exclude-dir='_Lib' --exclude-dir='Zeugs'
