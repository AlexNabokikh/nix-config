{ config, ... }:
let
  inherit (config.flake.modules)
    generic
    nixos
    darwin
    homeManager
    ;
  commonImports = [
    generic.homeManagerIntegration
    generic.nixSettings
    generic.primaryUser
    generic.primaryUserHome
    generic.profile
  ];
in
{
  flake.modules.generic.homeManagerIntegration = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ homeManager.base ];
    };
  };

  flake.modules.nixos.base = {
    imports = commonImports ++ [
      nixos.audio
      nixos.bluetooth
      nixos.boot
      nixos.fonts
      nixos.locale
      nixos.networking
      nixos.podman
      nixos.users
      nixos.zsh
    ];
  };

  flake.modules.darwin.base = {
    imports = commonImports ++ [
      darwin.brave
      darwin.fonts
      darwin.keyboard
      darwin.mos
      darwin.systemPreferences
      darwin.users
      darwin.zsh
    ];
  };

  flake.modules.homeManager.base = {
    imports = [
      generic.profile
      homeManager.alacritty
      homeManager.atuin
      homeManager.aws
      homeManager.brave
      homeManager.btop
      homeManager.catppuccin
      homeManager.eza
      homeManager.fastfetch
      homeManager.fzf
      homeManager.git
      homeManager.go
      homeManager.gpg
      homeManager.k8s
      homeManager.neovim
      homeManager.opencode
      homeManager.opentofu
      homeManager.packages
      homeManager.podman
      homeManager.scripts
      homeManager.starship
      homeManager.tmux
      homeManager.xdg
      homeManager.zsh
    ];
  };
}
