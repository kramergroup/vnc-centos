DOCKER_CONTAINER=vnc-centos

.PHONY: container
container: assets/vncd
	docker build . -t ${DOCKER_CONTAINER}

assets/vncd: dependencies/vncd/bin/vncd
	cp $< $@

dependencies/vncd/bin/vncd: $(shell find dependencies/vncd/src -name *.go)
	export ASSET=$(shell pwd)/$@
	$(MAKE) -C dependencies/vncd -e
