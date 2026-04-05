{ inputs, config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
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
        nixpkgs.config.allowUnfree = true;
        primaryUser = username;
        system.stateVersion = 6;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = {
            imports = [
              inputs.catppuccin.homeModules.catppuccin

              # Common
              homeManager.common
              homeManager.scripts

              # Programs
              homeManager.programsAerospace
              homeManager.programsAlacritty
              homeManager.programsAtuin
              homeManager.programsBat
              homeManager.programsBrave
              homeManager.programsBtop
              homeManager.programsFastfetch
              homeManager.programsFzf
              homeManager.programsGit
              homeManager.programsGo
              homeManager.programsGpg
              homeManager.programsK8s
              homeManager.programsLazygit
              homeManager.programsNeovim
              homeManager.programsSaml2aws
              homeManager.programsStarship
              homeManager.programsTelegram
              homeManager.programsTmux
              homeManager.programsZsh
            ];

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
