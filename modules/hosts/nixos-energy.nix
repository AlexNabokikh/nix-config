{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
  inherit (config) hmProfiles;
  username = "nabokikh";
in
{
  flake.nixosConfigurations.energy = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # Hardware
      inputs.hardware.nixosModules.asus-rog-strix-x570e
      inputs.hardware.nixosModules.common-gpu-amd
      ./_energy-hardware.nix

      # NixOS system modules
      nixos.common
      nixos.desktopWaylandCommon
      nixos.desktopHyprland
      nixos.gaming

      # Home-manager integration
      inputs.home-manager.nixosModules.home-manager

      # Host-specific configuration
      {
        networking.hostName = "energy";
        primaryUser = username;
        system.stateVersion = "26.05";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = {
            imports = hmProfiles.core ++ hmProfiles.linuxDesktop ++ hmProfiles.hyprland;

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
