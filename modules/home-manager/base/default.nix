{ config, inputs, ... }:
let
  inherit (config.flake.modules) generic homeManager;
in
{
  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      inputs.catppuccin.homeModules.catppuccin
      homeManager.scripts
      homeManager.programsAlacritty
      homeManager.programsAtuin
      homeManager.programsBtop
      homeManager.programsFastfetch
      homeManager.programsFzf
      homeManager.programsGit
      homeManager.programsGo
      homeManager.programsGpg
      homeManager.programsK8s
      homeManager.programsNeovim
      homeManager.programsSaml2aws
      homeManager.programsStarship
      homeManager.programsTmux
      homeManager.programsZsh
    ];
  };
}
