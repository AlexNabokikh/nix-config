{ inputs, config, ... }:
let
  inherit (config.flake.modules)
    generic
    nixos
    darwin
    homeManager
    ;
  commonImports = [
    generic.fonts
    generic.homeManagerIntegration
    generic.nixSettings
    generic.primaryUser
    generic.profile
  ];
in
{
  flake.modules.generic.homeManagerIntegration =
    { config, lib, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ homeManager.base ];
        users.${config.primaryUser}.home.stateVersion = lib.mkDefault "26.05";
      };
    };

  flake.modules.nixos.base = {
    imports = commonImports ++ [
      inputs.home-manager.nixosModules.home-manager
      nixos.audio
      nixos.bluetooth
      nixos.boot
      nixos.locale
      nixos.networking
      nixos.podman
      nixos.users
      nixos.zsh
    ];
  };

  flake.modules.darwin.base = {
    imports = commonImports ++ [
      inputs.home-manager.darwinModules.home-manager
      darwin.brave
      darwin.keyboard
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
      homeManager.stylix
      homeManager.tmux
      homeManager.xdg
      homeManager.zsh
    ];
  };
}
