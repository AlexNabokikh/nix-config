{ config, ... }:
let
  inherit (config.flake.modules) generic;
in
{
  flake.modules.darwin.base = {
    imports = [
      generic.profile
      generic.primaryUser
      generic.nixSettings
    ];
  };
}
