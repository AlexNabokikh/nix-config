{
  flake.modules.homeManager.desktopQt =
    {
      config,
      pkgs,
      ...
    }:
    let
      qtFont = family: size: ''"${family},${toString size}"'';
      uiFont = qtFont config.profile.appearance.fonts.ui.family config.profile.appearance.fonts.ui.size;
      monospaceFont = qtFont config.profile.appearance.fonts.monospace.family config.profile.appearance.fonts.ui.size;
    in
    {
      qt = {
        enable = true;
        platformTheme = {
          name = "qtct";
          package = pkgs.kdePackages.qt6ct;
        };
        style.name = "kvantum";
        qt6ctSettings = {
          Appearance.icon_theme = config.profile.appearance.iconTheme.name;
          Fonts = {
            general = uiFont;
            fixed = monospaceFont;
          };
        };
      };

      xdg.desktopEntries = {
        qt6ct = {
          name = "qt6ct";
          noDisplay = true;
        };

        kvantummanager = {
          name = "kvantum";
          noDisplay = true;
        };
      };
    };
}
