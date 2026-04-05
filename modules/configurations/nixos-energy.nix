{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
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
        nixpkgs.config.allowUnfree = true;
        networking.hostName = "energy";
        primaryUser = username;
        system.stateVersion = "26.05";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = {
            imports = [
              inputs.catppuccin.homeModules.catppuccin

              # Common
              homeManager.common
              homeManager.scripts

              # Programs
              homeManager.programsAlacritty
              homeManager.programsAtuin
              homeManager.programsBat
              homeManager.programsBrave
              homeManager.programsBtop
              homeManager.programsFastfetch
              homeManager.programsFzf
              homeManager.programsGit
              homeManager.programsGo
              homeManager.programsGpg
              homeManager.programsK8s
              homeManager.programsLazygit
              homeManager.programsNeovim
              homeManager.programsSaml2aws
              homeManager.programsStarship
              homeManager.programsTelegram
              homeManager.programsTmux
              homeManager.programsZsh

              # Desktop (Hyprland + Wayland common + misc)
              homeManager.desktopHyprland
              homeManager.desktopWaylandCommon
              homeManager.miscGtk
              homeManager.miscQt
              homeManager.miscXdg
              homeManager.programsNoctalia
              homeManager.programsSwappy
              homeManager.servicesHypridle
              homeManager.servicesKanshi
            ];

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
