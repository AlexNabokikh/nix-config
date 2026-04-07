{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackLinuxBase = {
    imports = [ nixos.base ];

    home-manager.sharedModules = [
      homeManager.base
    ];
  };
}
