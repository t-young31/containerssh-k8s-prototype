SHELL := /bin/bash
.PHONY: *


build-x86:
	. ../init.sh && \
	docker buildx build \
		--platform linux/amd64 \
		--label org.opencontainers.image.source="https://github.com/$$GITHUB_REPO" \
		--tag "$$GUEST_IMAGE" \
		.

push: build-x86
	. ../init.sh && \
	docker push "$$GUEST_IMAGE"
