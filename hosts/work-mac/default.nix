{ inputs, stacks, ... }:
let
  username = "alexander.nabokikh";
in
{
  flake.darwinConfigurations."PL-OLX-KCGXHGK3PY" = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      inputs.home-manager.darwinModules.home-manager
      stacks.darwinBase
      stacks.aerospace
      {
        primaryUser = username;
        system.stateVersion = 6;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = {
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
