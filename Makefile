.PHONY: bootstrap-mac install-nix install-nix-darwin

bootstrap-mac: install-nix install-nix-darwin

install-nix:
	@echo "Installing Nix..."
	@sudo curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
	@echo "Nix installation complete."

install-nix-darwin:
	@echo "Installing nix-darwin..."
	@nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#$(hostname)
	@echo "nix-darwin installation complete."
