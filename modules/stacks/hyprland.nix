{ config, ... }:
let
  inherit (config.flake.modules) generic homeManager nixos;
in
{
  flake.modules.nixos.stackHyprland = {
    imports = [
      generic.noctaliaCache
      nixos.desktopCompositorCommon
      nixos.desktopHyprland
    ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorCommon
      homeManager.desktopHyprland
    ];
  };
}
