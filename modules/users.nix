{
  flake.modules.generic.primaryUser =
    { lib, ... }:
    {
      options.primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "Primary username for this system";
      };
    };

  flake.modules.nixos.users =
    {
      config,
      ...
    }:
    {
      users.users.${config.primaryUser} = {
        description = config.profile.fullName;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        isNormalUser = true;
      };

      security.sudo.wheelNeedsPassword = false;
    };

  flake.modules.darwin.users =
    { config, ... }:
    {
      users.users.${config.primaryUser} = {
        home = "/Users/${config.primaryUser}";
      };

      security.sudo.extraConfig = "${config.primaryUser}    ALL = (ALL) NOPASSWD: ALL";

      system.primaryUser = config.primaryUser;
    };
}
