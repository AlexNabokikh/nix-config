{
  inputs,
  hostname,
  nixosModules,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-z13-gen1

    ./hardware-configuration.nix
    "${nixosModules}/common"
    "${nixosModules}/services/tlp"
    "${nixosModules}/desktop/hyprland"
  ];

  # Set hostname
  networking.hostName = hostname;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11";
}
