{
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
          "video"
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
