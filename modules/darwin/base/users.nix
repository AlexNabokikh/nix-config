{ ... }:
{
  flake.modules.darwin.users =
    {
      config,
      lib,
      ...
    }:
    {
      options.primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "Primary username for this system";
      };

      config = {
        users.users.${config.primaryUser} = {
          name = config.primaryUser;
          home = "/Users/${config.primaryUser}";
        };

        programs.zsh.enable = true;
        system.primaryUser = config.primaryUser;
      };
    };
}
