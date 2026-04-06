{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackNiri = {
    imports = [
      nixos.desktopCompositorBase
      nixos.desktopNiri
    ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorBase
      homeManager.desktopNiri
    ];
  };
}
