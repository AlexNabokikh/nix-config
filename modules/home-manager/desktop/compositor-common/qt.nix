{ ... }:
{
  flake.modules.homeManager.desktopCompositorBase =
    {
      config,
      pkgs,
      ...
    }:
    {
      qt = {
        enable = true;
        platformTheme = {
          name = "qtct";
          package = pkgs.kdePackages.qt6ct;
        };
        style.name = "kvantum";
        qt6ctSettings.Appearance.icon_theme = config.profile.appearance.iconTheme.name;
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
