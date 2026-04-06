{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.desktopCompositorCommon = {
    imports = [
      hm.desktopCursor
      hm.desktopDconf
      hm.desktopGtk
      hm.desktopQt
      hm.desktopXdg
      hm.programsNoctalia
      hm.programsSwappy
      hm.servicesHypridle
    ];
  };
}
