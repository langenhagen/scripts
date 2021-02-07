#!/bin/bash
# Compile a given single C++ file, immediately run and afterwards remove the executable.
#
# author: andreasl

file="$1"
g++ -Wall "$file" -o "${file}.o" && "./${file}.o" && rm "${file}.o"
