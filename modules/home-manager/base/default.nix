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
      homeManager.programsGranted
      homeManager.programsK8s
      homeManager.programsNeovim
      homeManager.programsStarship
      homeManager.programsTmux
      homeManager.programsZsh
    ];
  };
}
