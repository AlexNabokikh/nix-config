{ config, inputs, ... }:
let
  inherit (config.flake.modules) generic homeManager;
in
{
  imports = [
    ./catppuccin.nix
    ./packages.nix
  ];

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      inputs.catppuccin.homeModules.catppuccin
      homeManager.baseCatppuccin
      homeManager.packages
      homeManager.scripts
      homeManager.programsAlacritty
      homeManager.programsAtuin
      homeManager.programsBrave
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
      homeManager.programsTelegram
      homeManager.programsTmux
      homeManager.programsZsh
    ];
  };
}
