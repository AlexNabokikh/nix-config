{ nixosModules, pkgs, ... }:
{
  imports = [
    "${nixosModules}/desktop/wayland-common"
  ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    grimblast
    hyprpicker
  ];
}
