{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  imports = [
    ./cursor.nix
    ./dconf.nix
    ./gtk-qt.nix
    ./xdg.nix
  ];

  flake.modules.homeManager.desktopCompositorCommon = {
    imports = [
      hm.desktopCompositorCursor
      hm.desktopCompositorDconf
      hm.desktopCompositorGtkQt
      hm.desktopCompositorXdg
    ];
  };

  flake.modules.homeManager.appearanceGtkQt = hm.desktopCompositorGtkQt;
}
