{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.nixos.fonts = {
    home-manager.sharedModules = [ homeManager.fonts ];
  };

  flake.modules.darwin.fonts =
    { config, ... }:
    {
      fonts.packages = [
        config.profile.appearance.fonts.monospace.package
      ];
    };

  flake.modules.homeManager.fonts =
    { config, ... }:
    {
      fonts.fontconfig.defaultFonts = {
        sansSerif = [ config.profile.appearance.fonts.ui.family ];
        monospace = [ config.profile.appearance.fonts.monospace.family ];
      };

      home.packages = [
        config.profile.appearance.fonts.ui.package
        config.profile.appearance.fonts.monospace.package
      ];
    };
}
