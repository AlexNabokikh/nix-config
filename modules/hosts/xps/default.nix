{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.xps.module = {
    imports = [
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.hardware.nixosModules.common-pc-laptop
      inputs.hardware.nixosModules.common-pc-ssd
      ./_hardware.nix
      nixos.base
      nixos.niri
    ];

    primaryUser = "nabokikh";
    system.stateVersion = "26.05";
  };
}
