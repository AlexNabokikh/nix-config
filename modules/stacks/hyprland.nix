{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.stackHyprland = {
    imports = [
      nixos._stackCompositorBase
      nixos.desktopHyprland
    ];

    home-manager.sharedModules = [
      homeManager.desktopHyprland
    ];
  };
}
