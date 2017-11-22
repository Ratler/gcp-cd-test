FROM alpine

COPY gopath/bin/gcp-cd-test /go/bin/gcp-cd-test

ENTRYPOINT /go/bin/gcp-cd-test
