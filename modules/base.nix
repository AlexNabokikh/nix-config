{ config, ... }:
let
  inherit (config.flake.modules) generic homeManager;
  systemImports = [
    generic.profile
    generic.primaryUser
    generic.primaryUserHome
    generic.nixSettings
  ];
in
{
  flake.modules.nixos.base = {
    imports = systemImports;
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.darwin.base = {
    imports = systemImports;
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      homeManager.scripts
      homeManager.alacritty
      homeManager.atuin
      homeManager.btop
      homeManager.fastfetch
      homeManager.fzf
      homeManager.git
      homeManager.go
      homeManager.gpg
      homeManager.granted
      homeManager.k8s
      homeManager.neovim
      homeManager.starship
      homeManager.tmux
      homeManager.zsh
    ];
  };
}
