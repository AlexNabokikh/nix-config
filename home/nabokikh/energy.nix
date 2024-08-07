{...}: {
  imports = [
    ../modules/common.nix
    ../modules/corectrl.nix
    ../modules/easyeffects.nix
    ../modules/hyprland.nix
  ];

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
