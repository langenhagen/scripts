#!/bin/sh
#
# Executes the input arguments as a command or
# pipes the input stream and
# prints the output with every second column colored differently.
#
# author: andreasl
# version 18-07-07

# decide whether we take input from pipe | or from input parameter list
if [ $# -eq 0 ] ; then
    command_output=`cat`
else
    command_output=`$@`
fi

# TODO adjust colors
read -r -d '' scriptVariable << 'EOF'
{
    for (i=1; i<=NF; ++i) {
        if(i%2) {
            printf ("%s%s%s", "\e[1;31m", $i, "\e[0m ");
        } else {
            printf ("%s%s%s", "\e[1;34m", $i, "\e[0m ");
        }
    }
}
EOF

# 4 (sic!) backslashes apparently escape one or more backslashes with this quoting scheme
regex_var='[\\\\|/|\:|\||\.|[:space:]]*'
# TODO how to print the CURRENT delimeter?
echo "This/is/a:test.txt\yeah..yes\\wtf|what       it      this works\\\\\\I tell you"
echo "This/is/a:test.txt\yeah..yes\\wtf|what       it      this works\\\\\\I tell you" | awk -F ${regex_var} "$scriptVariable"


# TODO:
# Better: write a c or a pytohn program that splits the string and also get retrieves the
# delimited elements in order to print fields in the scheme:
#   "field%2_color" + "delimeter_color" + "field(%2+§)_color"

# google: string split regex keep delimeters
