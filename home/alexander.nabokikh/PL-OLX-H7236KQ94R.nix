{outputs, ...}: {
  imports = [
    ../modules/alacritty.nix
    ../modules/atuin.nix
    ../modules/bat.nix
    ../modules/bottom.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    # ../modules/git.nix
    ../modules/go.nix
    # ../modules/gpg.nix
    ../modules/krew.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/saml2aws.nix
    ../modules/spicetify.nix
    ../modules/tmux.nix
    ../modules/zoom.nix
    ../modules/zsh.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  home.username = "alexander.nabokikh";
  home.homeDirectory = "/Users/alexander.nabokikh";

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

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
