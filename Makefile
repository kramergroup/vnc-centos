DOCKER_CONTAINER=vnc-centos

.PHONY: container
container: Dockerfile $(shell find assets)
	docker build . -t ${DOCKER_CONTAINER}
