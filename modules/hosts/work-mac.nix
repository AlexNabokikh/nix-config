{ config, ... }:
let
  inherit (config.flake.modules) darwin;
in
{
  configurations.darwin."PL-OLX-KCGXHGK3PY".module = {
    imports = [
      darwin.base
      darwin.aerospace
    ];

    primaryUser = "alexander.nabokikh";
    system.stateVersion = 7;
  };
}
