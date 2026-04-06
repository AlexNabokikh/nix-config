{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
  username = "nabokikh";
in
{
  configurations.nixos.energy.modules = [
    inputs.hardware.nixosModules.asus-rog-strix-x570e
    inputs.hardware.nixosModules.common-gpu-amd
    ./hardware.nix
    nixos.stackLinuxBase
    nixos.stackHyprland
    nixos.gaming
    {
      primaryUser = username;
      system.stateVersion = "26.05";

      home-manager.users.${username} = {
        programs.home-manager.enable = true;
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion = "26.05";
        };
      };
    }
  ];
}
