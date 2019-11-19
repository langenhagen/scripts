#!/bin/bash
# Validate the given yaml file via python.
# Requires Python and the Python package pyyaml to be available.
#
# based on:
# https://stackoverflow.com/questions/3971822/how-do-i-validate-my-yaml-file-from-command-line
#
# author: andreasl

if python -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < "$1" >/dev/null; then
    printf "Yaml valid.\n"
else
    exit 1
fi
