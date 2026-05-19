{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.darwin.aerospace = {
    home-manager.sharedModules = [
      homeManager.aerospace
    ];
  };

  flake.modules.homeManager.aerospace = {
    programs.aerospace = {
      enable = true;
      launchd.enable = true;
      settings = fromTOML (builtins.readFile ./aerospace.toml);
    };
  };
}
