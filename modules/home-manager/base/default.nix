{ config, inputs, ... }:
let
  inherit (config.flake.modules) generic homeManager;
in
{
  imports = [
    ./packages.nix
  ];

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      inputs.catppuccin.homeModules.catppuccin
      homeManager.packages
      homeManager.scripts
      homeManager.programsAlacritty
      homeManager.programsAtuin
      homeManager.programsBat
      homeManager.programsBrave
      homeManager.programsBtop
      homeManager.programsFastfetch
      homeManager.programsFzf
      homeManager.programsGit
      homeManager.programsGo
      homeManager.programsGpg
      homeManager.programsK8s
      homeManager.programsLazygit
      homeManager.programsNeovim
      homeManager.programsSaml2aws
      homeManager.programsStarship
      homeManager.programsTelegram
      homeManager.programsTmux
      homeManager.programsZsh
    ];
  };
}
