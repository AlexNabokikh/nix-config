{ config, inputs, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  imports = [
    ./packages.nix
  ];

  flake.modules.homeManager.base = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
      hm.packages
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
  };
}
