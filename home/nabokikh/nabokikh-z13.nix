{nhModules, ...}: {
  imports = [
    "${nhModules}/common"
    "${nhModules}/programs/hyprland"
    "${nhModules}/programs/zoom"
    "${nhModules}/services/easyeffects"
    "${nhModules}/services/ulauncher"
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
