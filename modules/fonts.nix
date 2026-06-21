{
  flake.modules.darwin.fonts =
    { config, ... }:
    {
      fonts.packages = [
        config.profile.appearance.fonts.monospace.package
      ];
    };

  flake.modules.homeManager.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        fonts.fontconfig = {
          enable = true;
          defaultFonts = {
            sansSerif = [ config.profile.appearance.fonts.ui.family ];
            monospace = [ config.profile.appearance.fonts.monospace.family ];
          };
        };

        home.packages = [
          config.profile.appearance.fonts.ui.package
          config.profile.appearance.fonts.monospace.package
        ];
      };
    };
}
