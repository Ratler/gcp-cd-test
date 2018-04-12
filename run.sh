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
elif [ "$1" = "buildgo" ]; then
  export GOPATH=$PWD
  mkdir -p src/github.com/Ratler $PWD/dist
  ln -sf $PWD/gcp-cd-test src/github.com/Ratler/gcp-cd-test
  echo "Gopath is: " $GOPATH
  echo "pwd is: " $PWD
  cd src/github.com/Ratler/gcp-cd-test
  go build -o $GOPATH/dist/gcp-cd-test ./main.go
  cp Dockerfile $GOPATH/dist/Dockerfile
  cd $GOPATH
  ls -l dist/
elif [ "$1" = "build" ]; then
  docker run --rm -v $PWD:/go/gcp-cd-test golang:1.7.1 bash /go/gcp-cd-test/run.sh buildgo
  cd dist
  docker build . -t gcp-cd-test:latest
else
  docker run --rm -t -v $PWD:/go/gcp-cd-test golang:1.7.1 bash /go/gcp-cd-test/run.sh test
fi
