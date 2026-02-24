#!/usr/bin/env bash
# Compile a given single C++ file and immediately run it.
# Remove the executable afterwards.
#
# Usage:
#
#  playground-cpp-compile.sh [-k|--keep] FILE [PARAMS]...
#
# Examples:
#
#  playground-cpp-compile.sh main.cpp           # compile the program, run it and delete it afterwards
#  playground-cpp-compile.sh main.cpp -myarg    # compile the program, run it with -myarg and delete it afterwards
#  playground-cpp-compile.sh -k main.cpp        # compile the program, run it and don't delete it afterwards
#
# author: andreasl

keep_artifacts=false
while [ "$#" -gt 0 ]; do
    case "$1" in
    -k | --keep)
        keep_artifacts=true
        ;;
    *)
        file="$1"
        shift
        params=("$@")
        break
        ;;
    esac
    shift
done

# if g++ "${params[@]}" -pthread "$file" -o "${file}.o"; then
if clang++ "${params[@]}" -pthread "$file" -o "${file}.o"; then
# if clang++ --std=c++11 "${params[@]}" -pthread "$file" -o "${file}.o"; then
    "./${file}.o";
    [ "$keep_artifacts" = 'true' ] || rm "${file}.o";
fi
