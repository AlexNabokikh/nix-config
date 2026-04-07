{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackHyprland = {
    imports = [
      nixos.desktopCompositorCommon
      nixos.desktopHyprland
    ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorCommon
      homeManager.desktopHyprland
    ];
  };
}
