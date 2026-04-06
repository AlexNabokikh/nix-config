{ config, ... }:
let
  inherit (config.flake.modules) generic;
in
{
  flake.modules.nixos.base = {
    imports = [
      generic.profile
      generic.primaryUser
    ];
  };
}
