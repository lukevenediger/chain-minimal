BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
COMMIT := $(shell git log -1 --format='%H')

# don't override user values
ifeq (,$(VERSION))
  VERSION := $(shell git describe --exact-match 2>/dev/null)
  # if VERSION is empty, then populate it with branch's name and raw commit hash
  ifeq (,$(VERSION))
    VERSION := $(BRANCH)-$(COMMIT)
  endif
endif

# Update the ldflags with the app, client & server names
ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=mini \
	-X github.com/cosmos/cosmos-sdk/version.AppName=minid \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT)

BUILD_FLAGS := -ldflags '$(ldflags)'

###############
# Local Setup #
###############

replace-gomod-checkers:
	@echo "--> replacing checkers module in go.mod"
	@go mod edit -replace github.com/lukevenediger/checkers=../checkers-minimal/

restore-gomod-checkers:
	@echo "--> restoring checkers module in go.mod"
	@go mod edit -dropreplace github.com/lukevenediger/checkers@v0.1.0
	@go get github.com/lukevenediger/checkers@main


###########
# Install #
###########

all: install

install:
	@echo "--> ensure dependencies have not been modified"
	@go mod verify
	@echo "--> installing minid"
	@go install $(BUILD_FLAGS) -mod=readonly ./cmd/minid

init:
	./scripts/init.sh

###########
# Testing #
###########

test:
	@echo "--> Running tests"
	go test -v ./...
