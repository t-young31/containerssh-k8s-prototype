SHELL := /bin/bash
.PHONY: *

build:
	docker build --tag auth_server .

build-x86:
	. ../init.sh && \
	docker buildx build \
		--label org.opencontainers.image.source="https://github.com/$$GITHUB_REPO" \
		--platform linux/amd64 \
		--tag auth_server \
		.

push: build-x86
	. ../init.sh && \
	docker tag auth_server "$$AUTH_SERVER_IMAGE" && \
	docker push "$$AUTH_SERVER_IMAGE"

up-server:
	docker compose -f tests/docker-compose.yaml up -d --build

test: up-server
	URL="http://localhost:8080" pytest -s
	docker compose -f tests/docker-compose.yaml down
