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

    qt6ctSettings = {
      Appearance = {
        icon_theme = config.gtk.iconTheme.name;
      };
    };
  };

  catppuccin.kvantum.enable = true;
}
