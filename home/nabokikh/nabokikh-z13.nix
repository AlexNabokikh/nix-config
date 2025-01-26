{...}: {
  imports = [
    ../../modules/home-manager/common
    ../../modules/home-manager/services/easyeffects
    ../../modules/home-manager/programs/hyprland
    ../../modules/home-manager/services/ulauncher
    ../../modules/home-manager/programs/zoom
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
