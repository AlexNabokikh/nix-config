{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.energy.module = {
    imports = [
      inputs.hardware.nixosModules.asus-rog-strix-x570e
      inputs.hardware.nixosModules.common-gpu-amd
      ./_hardware.nix
      nixos.stackLinuxBase
      nixos.stackHyprland
      nixos.gaming
    ];

    primaryUser = "nabokikh";
    system.stateVersion = "26.05";
  };
}
