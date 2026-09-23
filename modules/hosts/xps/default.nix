{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.xps.module = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      ./_hardware.nix
      nixos.base
      nixos.niri
    ];

    primaryUser = "nabokikh";
    system.stateVersion = "26.05";

    services.thermald.enable = true;
  };
}
