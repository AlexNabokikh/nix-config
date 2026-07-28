{
  flake.modules.homeManager.qt =
    { config, ... }:
    let
      qtFont = family: size: ''"${family},${toString size}"'';

      qtctSettings = {
        Appearance.icon_theme = config.profile.appearance.iconTheme.name;
        Fonts = {
          general = qtFont config.profile.appearance.fonts.ui.family config.profile.appearance.fonts.ui.size;
          fixed = qtFont config.profile.appearance.fonts.monospace.family config.profile.appearance.fonts.monospace.size;
        };
      };
    in
    {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
        qt5ctSettings = qtctSettings;
        qt6ctSettings = qtctSettings;
      };

      xdg.desktopEntries = {
        qt5ct = {
          name = "qt5ct";
          noDisplay = true;
        };

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
