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

      system.primaryUser = config.primaryUser;
    };
}
