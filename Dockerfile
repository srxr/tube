# Build tube and mt
FROM golang:1.15-alpine AS builder

RUN apk add --no-cache -U build-base pkgconf git

WORKDIR /src

COPY . .

RUN set -x; \
    make setup build; \
    \
    make ffmpeg; \
    make mt

# Runtime
FROM alpine:3.13

RUN apk --no-cache -U add ffmpeg ffmpeg-dev ca-certificates; \
    rm -rf /var/cache/apk/*

COPY --from=builder /src/tube /tube
COPY --from=builder /mt /usr/local/bin/mt

WORKDIR /data

COPY config.json /config.json

CMD ["/tube", "-c", "/config.json"]
