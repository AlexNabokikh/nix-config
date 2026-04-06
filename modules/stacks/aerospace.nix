{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.darwin.stackAerospace = {
    home-manager.sharedModules = [
      homeManager.desktopAerospace
    ];
  };
}
