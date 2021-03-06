FROM golang:1.13-alpine

LABEL maintainer="rzrbld <razblade@gmail.com>"

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GO111MODULE on
ENV GOPROXY https://proxy.golang.org

RUN  \
     apk add --no-cache git && \
     git clone https://github.com/minio/minio && cd minio/ && git checkout d4dcf1d7225a38ecf94abe7cbe7c69a93dc7c0b0 && cd pkg/madmin/examples/ && \
     git clone https://github.com/rzrbld/adminio-api && go build adminio-api/src/main.go && cp main /go/bin/adminio
	
FROM alpine:3.9

EXPOSE 8080

COPY --from=0 /go/bin/adminio /usr/bin/adminio

RUN  \
     apk add --no-cache ca-certificates 'curl>7.61.0' 'su-exec>=0.2' && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

CMD ["adminio"]
