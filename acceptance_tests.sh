#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR/cob_spec
if [ ! -d $DIR/cob_spec ]; then
    git clone git@github.com:8thlight/cob_spec.git cob_spec
fi
cd $DIR/cob_spec
mvn package
cp $DIR/SwiftServer/.build/debug/Server $DIR/cob_spec/
cp $DIR/cob_spec_config.txt $DIR/cob_spec/FitNesseRoot/HttpTestSuite/content.txt
java -jar fitnesse.jar -c "HttpTestSuite?suite&format=text"
