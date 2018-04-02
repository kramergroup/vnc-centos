# This makefile creates the docknetd asset to be embedded in other Container

ASSET=../../assets/docknetd

bin/docknetd: bin src/app.go
	docker run -t --rm \
						 -v $(shell pwd)/src:/go/src/app \
						 -v $(shell pwd)/bin:/go/bin \
						 -e CGO_ENABLED=0 \
						 -e GOOS=linux \
						 golang:onbuild \
						 go build -a -installsuffix cgo -o /go/bin/docknetd .

.PHONY: install
install: bin bin/docknetd
	cp bin/docknetd ${ASSET}

bin:
	mkdir -p bin

clean:
	rm -rf bin
