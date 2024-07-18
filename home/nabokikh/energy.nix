{...}: {
  imports = [
    ../modules/alacritty.nix
    ../modules/bat.nix
    ../modules/bottom.nix
    ../modules/corectrl.nix
    ../modules/easyeffects.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/gpg.nix
    ../modules/gtk.nix
    ../modules/hyprland.nix
    ../modules/krew.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/saml2aws.nix
    ../modules/scripts.nix
    ../modules/spicetify.nix
    ../modules/tmux.nix
    ../modules/ulauncher.nix
    ../modules/zoom.nix
    ../modules/zsh.nix
  ];

  # Nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "nabokikh";
    homeDirectory = "/home/nabokikh";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
