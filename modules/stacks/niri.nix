{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackNiri = {
    imports = [
      nixos.desktopCompositorCommon
      nixos.desktopNiri
    ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorCommon
      homeManager.desktopNiri
    ];
  };
}
