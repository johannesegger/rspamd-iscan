# see https://github.com/JustinGuese/rspamd-iscan/blob/main/Dockerfile

FROM golang:alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ENV CGO_ENABLED=0
RUN go build -o rspamd-iscan main.go

##########

FROM alpine

COPY --from=builder /build/rspamd-iscan /usr/local/bin/rspamd-iscan

USER nobody

ENTRYPOINT ["/usr/local/bin/rspamd-iscan"]
CMD ["--cfg-file", "/etc/rspamd-iscan/config.toml"]
