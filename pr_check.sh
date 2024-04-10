#!/bin/bash

PR_CHECK_BUILD='true'

source build_deploy.sh

# Stubbed out for now
mkdir -p "artifacts"
cat << EOF > "artifacts/junit-dummy.xml"
<testsuite tests="1">
    <testcase classname="dummy" name="dummytest"/>
</testsuite>
EOF
