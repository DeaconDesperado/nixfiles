.PHONY: all update build

all: update build

update:
	nix flake update

build:
	nix build --fallback --show-trace .#darwinConfigurations.XW6K07YF0K.system
