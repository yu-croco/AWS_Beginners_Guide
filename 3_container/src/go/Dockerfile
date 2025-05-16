FROM --platform=linux/amd64 golang:1.22

ADD . /go/src/

EXPOSE 8080

CMD ["/usr/local/go/bin/go", "run", "/go/src/main.go"]
