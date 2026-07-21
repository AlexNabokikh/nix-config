{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.energy.module = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      ./_hardware.nix
      nixos.base
      nixos.niri
      nixos.gaming
    ];

    primaryUser = "nabokikh";
    system.stateVersion = "26.05";
  };
}
