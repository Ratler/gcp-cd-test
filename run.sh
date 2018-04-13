#!/bin/bash

set -e -o pipefail

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
  if [ -d "$GOPATH/gcp-cd-test/dist "]; then
    rm -rf $GOPATH/gcp-cd-test/dist
  fi
  mkdir -p src/github.com/Ratler $GOPATH/gcp-cd-test/dist
  ln -sf $PWD/gcp-cd-test src/github.com/Ratler/gcp-cd-test
  echo "Gopath is: " $GOPATH
  echo "pwd is: " $PWD
  cd src/github.com/Ratler/gcp-cd-test
  go build -o $GOPATH/gcp-cd-test/dist/gcp-cd-test ./main.go
  cp Dockerfile $GOPATH/gcp-cd-test/dist/Dockerfile
  cd $GOPATH
  chown -R 999:999 gcp-cd-test/dist
  ls -l gcp-cd-test/dist/
elif [ "$1" = "build" ]; then
  docker run --rm -v $PWD:/go/gcp-cd-test golang:1.7.1 bash /go/gcp-cd-test/run.sh buildgo
  cd dist
  docker build . -t gcp-cd-test:latest
elif [ "$1" = "push" ]; then
  eval $(aws ecr get-login --region $AWS_REGION)
  docker tag gcp-cd-test:latest ${DOCKER_REGISTRY}:${GO_REVISION}
  echo "Pushing ${DOCKER_REGISTRY}:${GO_REVISION}"
  docker push ${DOCKER_REGISTRY}:${GO_REVISION}
else
  docker run --rm -t -v $PWD:/go/gcp-cd-test golang:1.7.1 bash /go/gcp-cd-test/run.sh test
fi
