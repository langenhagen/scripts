#!/bin/bash
#
# Gives a system overview over things that I check from time to time.
#
# author: andreasl

printf '$ conda env list:\n'
conda env list;
printf '\n'

printf '$ reposet all:\n'
reposet all;
printf '\n'

