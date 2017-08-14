#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ ! -d $DIR/cob_spec ]; then
    git clone git@github.com:8thlight/cob_spec.git cob_spec
    cd $DIR/cob_spec
    mvn package
fi
swift package clean
swift build
cp $DIR/.build/debug/Main $DIR/cob_spec/
cp $DIR/cob_spec_config.txt $DIR/cob_spec/FitNesseRoot/HttpTestSuite/content.txt
cd $DIR/cob_spec
java -jar fitnesse.jar -p 9090
