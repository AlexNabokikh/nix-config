{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  imports = [
    ./compositor-common
    ./hyprland
    ./niri
    ./aerospace
  ];

  flake.modules.homeManager.desktopCompositorBase = {
    imports = [
      hm.desktopCompositorCommon
      hm.programsNoctalia
      hm.programsSwappy
      hm.servicesHypridle
      hm.servicesKanshi
    ];
  };
}
