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

  # Enable xwayland
  programs.xwayland.enable = true;

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    grimblast
    hyprpicker
  ];
}
