{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackHyprland = {
    imports = [
      nixos.desktopCompositorBase
      nixos.desktopHyprland
    ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorBase
      homeManager.desktopHyprland
    ];
  };
}
