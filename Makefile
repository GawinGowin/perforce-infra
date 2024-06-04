IMAGE_NAME := "x-tech-perforce"
TAG := "latest"

all:
	cd terraform && terraform apply --auto-approve

build:
	docker build . --file Dockerfile -t $(IMAGE_NAME):$(TAG)

run:
	docker run --name $(IMAGE_NAME) -d -p 1666:1666 -e P4D_PASSWORD=default_password $(IMAGE_NAME):$(TAG) 

PHONY: all build run
