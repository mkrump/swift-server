#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ ! -d $DIR/cob_spec ]; then
    git clone git@github.com:8thlight/cob_spec.git cob_spec
    cd $DIR/cob_spec
    mvn package
fi
cd $DIR/SwiftServer
swift build
cp $DIR/SwiftServer/.build/debug/Main $DIR/cob_spec/
cp $DIR/cob_spec_config.txt $DIR/cob_spec/FitNesseRoot/HttpTestSuite/content.txt
cd $DIR/cob_spec
java -jar fitnesse.jar -p 9090