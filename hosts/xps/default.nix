{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware.nix
    ../../modules/nixos/gnome.nix
  ];

  user.name = "nabokikh";
  system.stateVersion = "26.05";

  services.thermald.enable = true;
}
