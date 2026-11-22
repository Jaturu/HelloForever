# Local checks; CI runs the same targets.
BIN := $(HOME)/.local/bin
LUAROCKS_BIN := $(HOME)/.luarocks/bin
export PATH := $(BIN):$(LUAROCKS_BIN):$(PATH)

.PHONY: check lint fmt fmt-check types test

check: lint fmt-check types test

lint:
	luacheck .

fmt:
	stylua .

fmt-check:
	stylua --check .

types:
	scripts/fetch-wow-api.sh
	lua-language-server --check . --configpath=.luals-check.json --checklevel=Warning

test:
	busted
