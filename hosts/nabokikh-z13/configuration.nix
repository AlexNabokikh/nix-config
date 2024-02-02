{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-z13

    ./hardware-configuration.nix
    ../common/common.nix
  ];

  # Set hostname
  networking.hostName = "nabokikh-z13";

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  programs.hyprland.enable = true;

  services.blueman.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    brightnessctl
    grim
    hyprpaper
    libnotify
    networkmanagerapplet
    pamixer
    pavucontrol
    slurp
    swappy
    swaylock-effects
    waybar
    wlr-randr
    wlsunset
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11";
}
