{ config, ... }:
let
  inherit (config.flake.modules)
    generic
    nixos
    darwin
    homeManager
    ;
  commonImports = [
    generic.profile
    generic.primaryUser
    generic.primaryUserHome
    generic.nixSettings
  ];
in
{
  flake.modules.nixos.base = {
    imports = commonImports ++ [
      nixos.audio
      nixos.bluetooth
      nixos.boot
      nixos.containers
      nixos.locale
      nixos.networking
      nixos.services
      nixos.users
      nixos.zsh
    ];
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.darwin.base = {
    imports = commonImports ++ [
      darwin.fonts
      darwin.keyboard
      darwin.sudo
      darwin.systemPreferences
      darwin.users
      darwin.zsh
    ];
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      homeManager.alacritty
      homeManager.atuin
      homeManager.bat
      homeManager.btop
      homeManager.catppuccin
      homeManager.fastfetch
      homeManager.fonts
      homeManager.fzf
      homeManager.git
      homeManager.go
      homeManager.gpg
      homeManager.granted
      homeManager.k8s
      homeManager.neovim
      homeManager.packages
      homeManager.scripts
      homeManager.starship
      homeManager.tmux
      homeManager.zsh
    ];
  };
}
