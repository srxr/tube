export GOPROXY = https://proxy.golang.org

.PHONY: dev setup build install image test release clean

CGO_ENABLED=0
VERSION=$(shell git describe --abbrev=0 --tags)
COMMIT=$(shell git rev-parse --short HEAD)
DOCKER?=$(shell which docker || which podman)

FFMPEG_EXT=tar.bz2
FFMPEG_PKG=ffmpeg-4.3.2
FFMPEG_SRC=http://ffmpeg.org/releases/$(FFMPEG_PKG).$(FFMPEG_EXT)
MT_SRC=${GOPATH}/src/github.com/mutschler/mt

ifeq ($(UNAME),Darwin)
	GOFLAGS = --ldflags '-extldflags "-static -Wl,--allow-multiple-definition"'
else
	GOFLAGS =
endif

all: dev

dev: build
	@./tube -v

setup:
	@go get github.com/GeertJohan/go.rice/rice

build: clean
	@command -v rice > /dev/null || make setup
	@go generate $(shell go list)/...
	@go build -trimpath \
		-tags "netgo static_build" -installsuffix netgo \
		-ldflags "-w -X main.Version=$(VERSION) -X main.Commit=$(COMMIT)" \
		.

install: build
	@go install

image:
	@$(DOCKER) build -t prologic/tube .

test: install
	@go test

release:
	@./tools/release.sh

clean:
	@git clean -f -d -X

ffmpeg:
	@wget -P /tmp $(FFMPEG_SRC)
	@tar -xf /tmp/$(FFMPEG_PKG).$(FFMPEG_EXT) -C /tmp/
	@cd /tmp/$(FFMPEG_PKG) && ./configure --disable-yasm --disable-programs --disable-doc --prefix=/tmp/ffmpeg && make --silent -j`nproc` && make install --silent

mt:
	@export LD_LIBRARY_PATH=/tmp/ffmpeg/lib/
	@export PKG_CONFIG_LIBDIR=/tmp/ffmpeg/lib/pkgconfig/
	@mkdir -p $(MT_SRC) && cd $(MT_SRC) && git clone https://github.com/mutschler/mt.git . \
		&& go mod init; go mod tidy \
		&& LD_LIBRARY_PATH=/tmp/ffmpeg/lib/ PKG_CONFIG_LIBDIR=/tmp/ffmpeg/lib/pkgconfig/ \
				go build -mod=readonly $(GOFLAGS) -o /mt
