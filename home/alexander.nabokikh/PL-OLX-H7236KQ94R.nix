{...}: {
  imports = [
    ../modules/git.nix
    ../modules/zsh.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  home.username = "alexander.nabokikh";
  home.homeDirectory = "/Users/alexander.nabokikh";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
