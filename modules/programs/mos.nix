{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.darwin.mos = {
    home-manager.sharedModules = [ homeManager.mos ];

    system.defaults.CustomUserPreferences."com.caldis.Mos".hideStatusItem = true;
  };

  flake.modules.homeManager.mos =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mos ];
    };
}
