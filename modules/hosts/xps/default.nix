{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.xps.module = {
    imports = [
      inputs.hardware.nixosModules.dell-xps-13-9350
      ./_hardware.nix
      nixos.base
      nixos.niri
    ];

    primaryUser = "nabokikh";
    system.stateVersion = "26.05";
  };
}
