{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos._stackCompositorBase = {
    imports = [ nixos.desktopCompositorCommon ];

    home-manager.sharedModules = [
      homeManager.desktopCompositorBase
    ];
  };
}
