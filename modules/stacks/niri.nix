{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackNiri = {
    imports = [
      nixos._stackCompositorBase
      nixos.desktopNiri
    ];

    home-manager.sharedModules = [
      homeManager.desktopNiri
    ];
  };
}
