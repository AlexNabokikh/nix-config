{ config, inputs, lib, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  options.hmProfiles = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    description = "Pre-defined home-manager module import groups";
  };

  config.hmProfiles = {
    # Core programs shared across all hosts
    core = [
      inputs.catppuccin.homeModules.catppuccin
      hm.common
      hm.scripts
      hm.programsAlacritty
      hm.programsAtuin
      hm.programsBat
      hm.programsBrave
      hm.programsBtop
      hm.programsFastfetch
      hm.programsFzf
      hm.programsGit
      hm.programsGo
      hm.programsGpg
      hm.programsK8s
      hm.programsLazygit
      hm.programsNeovim
      hm.programsSaml2aws
      hm.programsStarship
      hm.programsTelegram
      hm.programsTmux
      hm.programsZsh
    ];

    # Linux desktop environment modules (shared across compositors)
    linuxDesktop = [
      hm.desktopWaylandCommon
      hm.appearanceTheming
      hm.appearanceXdg
      hm.programsNoctalia
      hm.programsSwappy
      hm.servicesHypridle
      hm.servicesKanshi
    ];

    # Compositor-specific modules
    hyprland = [ hm.desktopHyprland ];
    niri = [ hm.desktopNiri ];

    # macOS-specific modules
    darwinExtras = [
      hm.programsAerospace
    ];
  };
}
