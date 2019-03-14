#!/bin/bash
#
# Searches for Makefiles throughout the given directory path
# and interactively asks for every Makefile target to make it depend on the special target .PYONY.
# If the user decides to make the target phony, the script adds a line stating
# .PHONY: <target> to the Makefile target.
#
# author: andreasl


arguments:
    path (default .)
    depth (default infinite)




use find -name 'Makefile'


f.e. Makefile
f.e. target
    check if it has phony already --> skip

    print file name
    target nameand its body.
    promt y/n

    if yes
        add PHONY


I want the make target + body one by one. how?

makefile_string="$(cat ${file_path})"

cat Makefile | sed -n "/\n.*:/p"  # apparently, sed cannot easily match across several lines.


perl -0777 -i.original -pe 's/\n.*://igs' Makefile


cat Makefile | perl -ne 'print if s/.*?((\d{1,3}\.){3}\d{1,3}).*/\1/'


clear; perl -0777 -ne 'while(m/(^\n*|\n\n).*\:.*\n(\t.*\n)+/g){print "$&\n------------------\n";}' Makefile
clear; perl -0777 -ne 'while(m/(^\n*|\n\n).*\:.+\n(\t.*\n)+/g){print "$&\n------------------\n";}' Makefile
                                               ^


clear; perl -0777 -ne 'while(m/.*\:.*\n(\t.*\n)+/g){print "----------------------\n$&\n======================\n";}' Makefile  # todo: filter out the phony one: pt
clear; perl -0777 -ne 'while(m/(^|.*\n).*\:.*\n(\t.*\n)+/g){print "----------------------\n$&\n======================\n";}' Makefile


clear; perl -0777 -ne 'while(m/(^|\n).+:.*\n(\t.*\n)+/g){print "----------------------\n$&\n======================\n";}' Makefile  # also gets the phony target
