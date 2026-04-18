{ ... }:
{
  flake.modules.generic.primaryUserHome =
    {
      config,
      pkgs,
      ...
    }:
    {
      home-manager.users.${config.primaryUser} = {
        programs.home-manager.enable = true;
        home = {
          username = config.primaryUser;
          homeDirectory =
            if pkgs.stdenv.hostPlatform.isDarwin then
              "/Users/${config.primaryUser}"
            else
              "/home/${config.primaryUser}";
          stateVersion = "26.05";
        };
      };
    };
}
