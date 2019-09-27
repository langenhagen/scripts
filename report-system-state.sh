#!/bin/bash
#
# Retrieve a system overview over things that I check from time to time.
#
# In future:
#  - check maybe Docker
#
# author: andreasl

printf '$ conda env list:\n'
conda env list;
printf '\n'

printf '$ reposet all:\n'
reposet all;
printf '\n'

