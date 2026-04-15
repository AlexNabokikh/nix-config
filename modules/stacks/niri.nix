{ config, ... }:
let
  inherit (config.flake.modules) generic homeManager nixos;
in
{
  flake.modules.nixos.stackNiri = {
    imports = [
      generic.noctaliaCache
      nixos.desktopCompositorCommon
      nixos.desktopNiri
    ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorCommon
      homeManager.desktopNiri
    ];
  };
}
