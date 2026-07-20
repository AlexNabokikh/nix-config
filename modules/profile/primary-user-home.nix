{
  flake.modules.generic.primaryUserHome =
    { config, ... }:
    {
      home-manager.users.${config.primaryUser}.home.stateVersion = "26.05";
    };
}
