#!/usr/bin/env -S bash -ex
# Check the documentation coverage.
#
# Note: This must be run from the sdk_extensions directory: scripts/check-doc.sh

### INPUT VARIABLES ################################################################################

VEROSE=false
if echo $* | grep -we '--verbose' -q; then VEROSE=true; fi

### PROGRAM ########################################################################################

cd $ACS_MAIN_DIR/sdk_extensions/doc

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
if [ $VERBOSE ]; then
    java -Djava.awt.headless=true -jar $PLANTUML_JAR -v -failonerror -o $PWD/images_generated "../**.(qml|cpp|dox)"
else
    java -Djava.awt.headless=true -jar $PLANTUML_JAR -v -failonerror -o $PWD/images_generated "../**.(qml|cpp|dox)" > plantuml_output.txt
fi

# build docs
doxygen Doxyfile > doxylog.txt 2>&1
# cat doxylog.txt # less verbose

python doxy-coverage.py --ignoredir ../../locationsdk/carlo/ xml > $DOC_COVERAGE

# general coverage check
if [ $VERBOSE ]; then
    ! grep '100% API documentation coverage' $DOC_COVERAGE && cat $DOC_COVERAGE && false
else
    ! grep '100% API documentation coverage' $DOC_COVERAGE && false
fi

# ignore missing Tag file warning in Doxygen warnings file
sed -i.bak '/error: Tag file.*/d' $WARN_LOGFILE

# fail if any errors in Doxygen warnings file
cat $WARN_LOGFILE
! [ -s $WARN_LOGFILE ]
