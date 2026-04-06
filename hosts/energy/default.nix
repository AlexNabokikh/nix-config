{ inputs, config, stacks, ... }:
let
  inherit (config.flake.modules) nixos;
  username = "nabokikh";
in
{
  flake.nixosConfigurations.energy = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.hardware.nixosModules.asus-rog-strix-x570e
      inputs.hardware.nixosModules.common-gpu-amd
      ./hardware.nix
      inputs.home-manager.nixosModules.home-manager
      stacks.linuxBase
      stacks.hyprland
      nixos.gaming
      {
        networking.hostName = "energy";
        primaryUser = username;
        system.stateVersion = "26.05";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = {
            programs.home-manager.enable = true;
            home = {
              username = username;
              homeDirectory = "/home/${username}";
              stateVersion = "26.05";
            };
          };
        };
      }
    ];
  };
}
