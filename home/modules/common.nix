# Module: Common Home Configuration
# Purpose: Base configuration imported by all user home configurations
# Platform: All
{outputs, ...}: {
  imports = [
    ../modules/atuin.nix
    ../modules/bat.nix
    ../modules/btop.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/scripts.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
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
