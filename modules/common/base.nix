# Wiring shared by NixOS and nix-darwin.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.user.name = lib.mkOption {
    type = lib.types.str;
    description = "Primary username for this system (set per host).";
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      channel.enable = false;

      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      optimise.automatic = true;
    };

    # Home Manager's zsh runs compinit itself.
    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
    };

    # Only the terminal font (used by alacritty) is managed; everything else uses the desktop's defaults.
    fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      sharedModules = [ ../home/base.nix ];
      users.${config.user.name}.home.stateVersion = lib.mkDefault "26.05";
    };
  };
}
