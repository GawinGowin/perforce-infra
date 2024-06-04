
LOCATION := asia-northeast1
PROJECT_ID := vivid-willow-381410
REPONAME := perforce-server

IMAGE_NAME := x-tech-perforce
TAG := latest

DOCKER_REGISTRY := $(LOCATION)-docker.pkg.dev/$(PROJECT_ID)/$(REPONAME)

apply:
	cd terraform && terraform apply --auto-approve

build:
	docker build . --file Dockerfile -t $(IMAGE_NAME):$(TAG)

run:
	docker run --name $(IMAGE_NAME) -d -p 1666:1666 -e P4D_PASSWORD=default_password $(IMAGE_NAME):$(TAG) 

push:
	docker tag $(IMAGE_NAME):$(TAG) $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(TAG)

PHONY: all build run push
