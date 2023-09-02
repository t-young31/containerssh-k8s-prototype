.PHONY: *

build:
	docker build -t ck8sserver .

test: build
	docker compose -f tests/docker-compose.yaml up -d
	URL="http://localhost:8080" pytest -s
	docker compose -f tests/docker-compose.yaml down
