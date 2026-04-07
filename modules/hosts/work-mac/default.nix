{ config, ... }:
let
  inherit (config.flake.modules) darwin;
  username = "alexander.nabokikh";
in
{
  configurations.darwin."PL-OLX-KCGXHGK3PY".module = {
    imports = [
      darwin.stackBase
      darwin.stackAerospace
    ];

    primaryUser = username;
    system.stateVersion = 6;

    home-manager.users.${username} = {
      programs.home-manager.enable = true;
      home = {
        inherit username;
        homeDirectory = "/Users/${username}";
        stateVersion = "26.05";
      };
    };
  };
}
