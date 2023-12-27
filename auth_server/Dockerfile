FROM golang:1.21.4-alpine

WORKDIR /app
RUN unset GOPATH

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build \
    go build -v -o server . && \
    chmod +x server

ENV BIND_URL="0.0.0.0:8080"
# ENV AUTHORIZED_KEYS_FILEPATH=__CHANGE_ME__

CMD ["/app/server"]
