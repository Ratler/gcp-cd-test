FROM golang:1.9 as builder
RUN go get -d -v github.com/Ratler/gcp-cd-test
WORKDIR /go/src/github.com/Ratler/gcp-cd-test
RUN go test -cover ./...
RUN go build -a -o gcp-cd-test .

FROM alpine
COPY --from=builder /go/src/github.com/Ratler/gcp-cd-test /go/bin/gcp-cd-test
# Quick and dirty workaround (musl and glibc should be compatible)
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
ENTRYPOINT /go/bin/gcp-cd-test
