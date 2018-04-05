FROM alpine

COPY gcp-cd-test /go/bin/gcp-cd-test

ENTRYPOINT /go/bin/gcp-cd-test
