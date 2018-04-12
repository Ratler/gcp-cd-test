#!/bin/bash

set -e -x -o pipefail
echo "pwd is: $PWD"
export GOPATH=$PWD
ls -l
mkdir -p src/github.com/Ratler
ln -sf $PWD/gcp-cd-test src/github.com/Ratler/gcp-cd-test
echo "Gopath is: " $GOPATH
echo "pwd is: " $PWD
cd src/github.com/Ratler/gcp-cd-test
ls -l
go test -cover ./... | tee test_coverage.txt
mv test_coverage.txt $GOPATH/coverage-results/
