# Module: Common Home Configuration
# Purpose: Base configuration imported by all user home configurations
# Platform: All
{outputs, ...}: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./scripts.nix
    ./starship.nix
    ./tmux.nix
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
