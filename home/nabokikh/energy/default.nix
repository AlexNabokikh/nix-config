{ hmModules, ... }:
{
  imports = [
    "${hmModules}/common"
    "${hmModules}/desktop/hyprland"
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
