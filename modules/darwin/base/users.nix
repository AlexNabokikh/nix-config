{
  flake.modules.darwin.base =
    { config, ... }:
    {
      users.users.${config.primaryUser} = {
        name = config.primaryUser;
        home = "/Users/${config.primaryUser}";
      };

      programs.zsh.enable = true;
      system.primaryUser = config.primaryUser;
    };
}
