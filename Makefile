# Variables (override these as needed)
HOSTNAME ?= $(shell hostname)
FLAKE ?= .#$(HOSTNAME)
HOME_TARGET ?= $(FLAKE)
EXPERIMENTAL ?= --extra-experimental-features "nix-command flakes"

.PHONY: help install-nix install-nix-darwin darwin-rebuild nixos-rebuild \
	home-manager-switch nix-gc flake-update flake-check bootstrap-mac

help:
	@echo "Available targets:"
	@echo "  install-nix          - Install the Nix package manager"
	@echo "  install-nix-darwin   - Install nix-darwin using flake $(FLAKE)"
	@echo "  darwin-rebuild       - Rebuild the nix-darwin configuration"
	@echo "  nixos-rebuild        - Rebuild the NixOS configuration"
	@echo "  home-manager-switch  - Switch the Home Manager configuration using flake $(HOME_TARGET)"
	@echo "  nix-gc               - Run Nix garbage collection"
	@echo "  flake-update         - Update flake inputs"
	@echo "  flake-check          - Check the flake for issues"
	@echo "  bootstrap-mac        - Install Nix and nix-darwin sequentially"

install-nix:
	@echo "Installing Nix..."
	@sudo curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
	@echo "Nix installation complete."

install-nix-darwin:
	@echo "Installing nix-darwin..."
	@nix run nix-darwin $(EXPERIMENTAL) -- switch --flake $(FLAKE)
	@echo "nix-darwin installation complete."

darwin-rebuild:
	@echo "Rebuilding darwin configuration..."
	@darwin-rebuild switch --flake $(FLAKE)
	@echo "Darwin rebuild complete."

nixos-rebuild:
	@echo "Rebuilding NixOS configuration..."
	@sudo nixos-rebuild switch --flake $(FLAKE)
	@echo "NixOS rebuild complete."

home-manager-switch:
	@echo "Switching Home Manager configuration..."
	@home-manager switch --flake $(HOME_TARGET)
	@echo "Home Manager switch complete."

nix-gc:
	@echo "Collecting Nix garbage..."
	@nix-collect-garbage -d
	@echo "Garbage collection complete."

flake-update:
	@echo "Updating flake inputs..."
	@nix flake update
	@echo "Flake update complete."

flake-check:
	@echo "Checking flake..."
	@nix flake check
	@echo "Flake check complete."

bootstrap-mac: install-nix install-nix-darwin
