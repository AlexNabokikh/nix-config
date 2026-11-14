{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Primary username for this system.";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Alexander Nabokikh";
        description = "Full name of the primary user.";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "alexander.nabokikh@olx.pl";
        description = "Email address used for Git commits.";
      };
      gitKey = lib.mkOption {
        type = lib.types.str;
        default = "C5810093";
        description = "OpenPGP key ID used for Git commit signing.";
      };
    };

    terminalFont = {
      family = lib.mkOption {
        type = lib.types.str;
        default = "MesloLGS Nerd Font Mono";
        description = "Monospace font family used in the terminal.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nerd-fonts.meslo-lg;
        description = "Package providing the terminal font.";
      };
      size = {
        linux = lib.mkOption {
          type = lib.types.number;
          default = 12;
          description = "Terminal font size on Linux.";
        };
        darwin = lib.mkOption {
          type = lib.types.number;
          default = 15;
          description = "Terminal font size on macOS.";
        };
      };
    };
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

    # Only the terminal font is managed; everything else uses the desktop's defaults.
    fonts.packages = [ config.terminalFont.package ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      sharedModules = [ ../home/base.nix ];
      users.${config.user.name}.home.stateVersion = lib.mkDefault "26.05";
    };
  };
}
