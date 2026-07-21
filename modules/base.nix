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
  flake.modules.generic.homeManagerIntegration = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  flake.modules.nixos.base = {
    imports = commonImports ++ [
      nixos.audio
      nixos.bluetooth
      nixos.boot
      nixos.locale
      nixos.networking
      nixos.podman
      nixos.users
      nixos.zsh
    ];
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.darwin.base = {
    imports = commonImports ++ [
      darwin.brave
      darwin.fonts
      darwin.keyboard
      darwin.mos
      darwin.sudo
      darwin.systemPreferences
      darwin.users
    ];
    home-manager.sharedModules = [ homeManager.base ];
  };

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      homeManager.alacritty
      homeManager.atuin
      homeManager.aws
      homeManager.bat
      homeManager.brave
      homeManager.btop
      homeManager.catppuccin
      homeManager.eza
      homeManager.fastfetch
      homeManager.fonts
      homeManager.fzf
      homeManager.git
      homeManager.go
      homeManager.gpg
      homeManager.k8s
      homeManager.mos
      homeManager.neovim
      homeManager.opencode
      homeManager.opentofu
      homeManager.packages
      homeManager.podman
      homeManager.scripts
      homeManager.starship
      homeManager.tmux
      homeManager.zsh
    ];
  };
}
