#!/bin/bash
# Compile a given single C++ file and immediately run it.
# Remove the executable afterwards.
#
# author: andreasl

file="$1"
shift
g++ "$@" -pthread "$file" -o "${file}.o" && { "./${file}.o"; rm "${file}.o"; }
