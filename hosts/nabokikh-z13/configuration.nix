{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-z13

    ./hardware-configuration.nix
    ../common/common.nix
  ];

  # hyprland test
  environment.systemPackages = with pkgs; [
    brightnessctl
    cliphist
    hyprpaper
    mako
    networkmanagerapplet
    pamixer
    pavucontrol
    swaylock
    wlogout
  ];

  # hyprland test
  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  services.blueman.enable = true;

  # Set hostname
  networking.hostName = "nabokikh-z13";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11";
}
