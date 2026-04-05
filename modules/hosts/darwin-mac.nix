{ inputs, config, ... }:
let
  inherit (config.flake.modules) darwin;
  inherit (config) hmProfiles;
  username = "alexander.nabokikh";
in
{
  flake.darwinConfigurations."PL-OLX-KCGXHGK3PY" = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      # Darwin system modules
      darwin.common

      # Home-manager integration
      inputs.home-manager.darwinModules.home-manager

      # Host-specific configuration
      {
        primaryUser = username;
        system.stateVersion = 6;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = {
            imports = hmProfiles.core ++ hmProfiles.darwinExtras;

            programs.home-manager.enable = true;
            home = {
              username = username;
              homeDirectory = "/Users/${username}";
              stateVersion = "26.05";
            };
          };
        };
      }
    ];
  };
}
