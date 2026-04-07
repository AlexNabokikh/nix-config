{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  flake.modules.darwin.stackBase = {
    imports = [ darwin.base ];

    home-manager.sharedModules = [
      homeManager.base
    ];
  };
}
