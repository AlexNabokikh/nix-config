{ nixosModules, pkgs, ... }:
{
  imports = [
    "${nixosModules}/desktop/wayland-common"
  ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    grim
    grimblast
    hyprpicker
    slurp
  ];
}
