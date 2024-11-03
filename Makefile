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

minid-list-wallets:
	minid keys list --keyring-backend test

minid-create-game:
	@ALICE_WALLET=$(minid keys list --keyring-backend test --output json | jq -r '.[] | select(.name == "alice") | .address')
	@BOB_WALLET=$(minid keys list --keyring-backend test --output json | jq -r '.[] | select(.name == "bob") | .address')
	@minid tx checkers create $$GAME_ID $$ALICE_WALLET $$BOB_WALLET \
		--from alice
		--yes
