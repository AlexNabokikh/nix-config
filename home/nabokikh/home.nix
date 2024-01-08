{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/bat.nix
    ../modules/flameshot.nix
    ../modules/fzf.nix
    ../modules/gtk.nix
    ../modules/krew.nix
    ../modules/neovim.nix
    ../modules/saml2aws.nix
    ../modules/spicetify.nix
    ../modules/tmux.nix
    ../modules/ulauncher.nix
    ../modules/zsh.nix
  ];

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "nabokikh";
    homeDirectory = "/home/nabokikh";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
