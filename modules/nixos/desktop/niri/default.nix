{ nixosModules, pkgs, ... }:
{
  imports = [
    "${nixosModules}/desktop/wayland-common"
  ];

  # Enable Niri
  programs.niri.enable = true;

  # Enable Xwayland
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
