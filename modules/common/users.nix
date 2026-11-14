{
  inputs,
  config,
  lib,
  ...
}:
{
  options.user = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Primary username for this system.";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      description = "Full name of the primary user.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Email address used for Git commits.";
    };
    gitKey = lib.mkOption {
      type = lib.types.str;
      description = "OpenPGP key ID used for Git commit signing.";
    };
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ ../home/base.nix ];
    users.${config.user.name}.home.stateVersion = lib.mkDefault "26.05";
  };
}
