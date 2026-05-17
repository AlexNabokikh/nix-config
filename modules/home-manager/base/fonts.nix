{
  flake.modules.homeManager.base =
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
            monospace = [
              config.profile.appearance.fonts.monospace.family
              config.profile.appearance.fonts.terminal.family
            ];
          };
        };

        home.packages = [
          config.profile.appearance.fonts.ui.package
          config.profile.appearance.fonts.monospace.package
          config.profile.appearance.fonts.terminal.package
        ];
      };
    };
}
