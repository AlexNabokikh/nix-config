# Module: Common Home Configuration
# Purpose: Base configuration imported by all user home configurations
# Platform: All
{outputs, ...}: {
  imports = [
    ./aider.nix
    ./amp.nix
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./environment.nix
    ./fastfetch.nix
    ./fuelcheck.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./scripts.nix
    ./scripts.nix
    ./starship.nix
    ./tmux.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      outputs.overlays.fish-no-tests
    ];
    config.allowUnfree = true;
  };

  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };

  # Disable version mismatch warning since we intentionally use unstable branches
  home.enableNixpkgsReleaseCheck = false;
}
