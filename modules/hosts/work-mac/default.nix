{ config, ... }:
let
  inherit (config.flake.modules) darwin;
in
{
  configurations.darwin."PL-OLX-KCGXHGK3PY".module = {
    imports = [
      darwin.stackBase
      darwin.stackAerospace
    ];

    primaryUser = "alexander.nabokikh";
    system.stateVersion = 6;
  };
}
