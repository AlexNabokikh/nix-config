# Wiring shared by NixOS and nix-darwin.
{
  config,
  lib,
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

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.user.name}.imports = [ ../home/base.nix ];
    };
  };
}
