#!/bin/bash

set -e -x -o pipefail

if [ "$1" = "test" ]; then
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
  mv test_coverage.txt $GOPATH/
else
  docker run --rm -t -v $PWD:/go/gcp-cd-test golang:1.7.1 bash /go/gcp-cd-test/run-tests.sh test
fi
