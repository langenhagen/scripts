#!/bin/bash -ex
# --------------------------------------------------------------------------------------------------
# Copyright (c) 2014 HERE Global B.V. including its affiliated companies.
# --------------------------------------------------------------------------------------------------
#
# Check the documentation coverage.
#
# Note: This must be run from the sdk_extensions directory: scripts/check-doc.sh

cd doc

eval `sed -ne 's/\s\+//g;/WARN_LOGFILE.*=/p' Doxyfile | tr -d ' '`
# langenhagen - 160418 - i added this one ____________^^^^^^^^^^^

rm -f $WARN_LOGFILE

DOC_COVERAGE=doc_coverage.txt
DOXYFILE_COPY=`mktemp`
cp -f Doxyfile $DOXYFILE_COPY

trap 'mv $DOXYFILE_COPY Doxyfile' EXIT

QHELPGENERATOR_BIN=`locate bin/qhelpgenerator | head -n 1`

[ -z "$QHELPGENERATOR_BIN" ] || \
        sed -i -re 's#QHELPGENERATOR_BIN=.*#QHELPGENERATOR_BIN='$QHELPGENERATOR_BIN'#' Doxyfile

# generate sequence diagrams etc. with PlantUML
export PLANTUML_JAR=`pwd`/plantuml.jar
java -Djava.awt.headless=true -jar $PLANTUML_JAR -v -failonerror -o $PWD/images_generated "../**.(qml|cpp|dox)"

# build docs
doxygen Doxyfile > doxylog.txt 2>&1
# cat doxylog.txt # less verbose

python doxy-coverage.py --ignoredir ../../locationsdk/carlo/ xml > $DOC_COVERAGE

# general coverage check
! grep '100% API documentation coverage' $DOC_COVERAGE && cat $DOC_COVERAGE && false

# ignore missing Tag file warning in Doxygen warnings file
sed -i.bak '/error: Tag file.*/d' $WARN_LOGFILE

# fail if any errors in Doxygen warnings file
cat $WARN_LOGFILE
! [ -s $WARN_LOGFILE ]

