{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.desktopCompositorBase = {
    imports = [
      hm.desktopCompositorCommon
      hm.programsNoctalia
      hm.programsSwappy
      hm.servicesHypridle
    ];
  };
}
