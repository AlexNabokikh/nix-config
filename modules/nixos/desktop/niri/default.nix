{ nixosModules, ... }:
{
  imports = [
    "${nixosModules}/desktop/wayland-common"
  ];

  # Enable Niri
  programs.niri.enable = true;
}
