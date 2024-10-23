.PHONY: bootstrap-mac install-nix install-nix-darwin darwin-rebuild

install-nix:
	@echo "Installing Nix..."
	@sudo curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
	@echo "Nix installation complete."

install-nix-darwin:
	@echo "Installing nix-darwin..."
	@nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#$(hostname)
	@echo "nix-darwin installation complete."

darwin-rebuild:
	@echo "Rebuilding darwin configuration..."
	@darwin-rebuild switch --flake .#$(hostname)
	@echo "Darwin rebuild complete."

bootstrap-mac: install-nix install-nix-darwin
