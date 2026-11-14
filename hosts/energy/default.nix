{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./hardware.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/gaming.nix
  ];

  user.name = "nabokikh";
  system.stateVersion = "26.05";
}
