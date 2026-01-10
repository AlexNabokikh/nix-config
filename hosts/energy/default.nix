{
  inputs,
  hostname,
  nixosModules,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.asus-rog-strix-x570e
    inputs.hardware.nixosModules.common-gpu-amd

    ./hardware-configuration.nix
    "${nixosModules}/common"
    "${nixosModules}/desktop/hyprland"
    "${nixosModules}/programs/steam"
  ];

  # Set hostname
  networking.hostName = hostname;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "26.05";
}
