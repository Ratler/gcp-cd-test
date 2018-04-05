FROM alpine

COPY gcp-cd-test /go/bin/gcp-cd-test

# Quick and dirty workaround (musl and glibc should be compatible)
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ENTRYPOINT /go/bin/gcp-cd-test
