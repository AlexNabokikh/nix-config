{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  variant = config.catppuccin.flavor;
  accent = config.catppuccin.accent;

  catppuccin-kvantum-pkg = pkgs.catppuccin-kvantum.override { inherit variant accent; };
  catppuccin-theme-name = "catppuccin-${variant}-${accent}";

  qtCtAppearanceConfig = generators.toINI { } {
    Appearance = {
      icon_theme = config.gtk.iconTheme.name;
    };
  };

in
{
  home.packages = [
    catppuccin-kvantum-pkg
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.libsForQt5.qt5ct
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/${catppuccin-theme-name}".source =
      "${catppuccin-kvantum-pkg}/share/Kvantum/${catppuccin-theme-name}";

    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = catppuccin-theme-name;
    };

    qt5ct = {
      target = "qt5ct/qt5ct.conf";
      text = qtCtAppearanceConfig;
    };

    qt6ct = {
      target = "qt6ct/qt6ct.conf";
      text = qtCtAppearanceConfig;
    };
  };
}
