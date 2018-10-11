#!/bin/sh

# Executes the input arguments as a command or
# pipes the input stream and
# prints the output with every second line colored differently.
#
# author: andreasl
# version 18-06-28

# decide whether we take input from pipe | or from input parameter list
if [ $# -eq 0 ] ; then
    command_output=`cat`
else
    command_output=`$@`
fi

readonly color1='\033[0m'
readonly color2='\033[90m'
readonly no_color='\033[0m'

cur_line=0
while IFS= read -r line; do  # declaring IFS configures read not to trim the given line
    (( cur_line = cur_line + 1 ))
    if [ $(( cur_line % 2 )) == 0 ] ; then
        printf "${color1}%s${no_color}\n" "$line"  # print with %s allows for special chars int the input, like %
    else
        printf "${color2}%s${no_color}\n" "$line"  # print with %s allows for special chars int the input, like %
    fi

done <<< "$command_output"
