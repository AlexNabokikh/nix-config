{ config, ... }:
{
  flake.modules.homeManager.desktopCompositorTheming =
    moduleArgs@{ lib, pkgs, ... }:
    let
      resolvePackage =
        packagePath:
        lib.attrByPath packagePath
          (throw "Profile package path not found: ${lib.concatStringsSep "." packagePath}")
          pkgs;
    in
    {
      catppuccin = {
        enable = true;
        flavor = config.profile.appearance.catppuccin.flavor;
        accent = config.profile.appearance.catppuccin.accent;
      };

      gtk = {
        enable = true;
        colorScheme = "dark";
        gtk2.force = true;
        gtk4.theme = moduleArgs.config.gtk.theme;
        theme = {
          name = "catppuccin-${moduleArgs.config.catppuccin.flavor}-${moduleArgs.config.catppuccin.accent}-compact";
          package = pkgs.catppuccin-gtk.override {
            accents = [ moduleArgs.config.catppuccin.accent ];
            variant = moduleArgs.config.catppuccin.flavor;
            size = "compact";
          };
        };
        iconTheme = lib.mkForce {
          name = config.profile.appearance.iconTheme.name;
          package = resolvePackage config.profile.appearance.iconTheme.packagePath;
        };
        cursorTheme = {
          name = config.profile.appearance.cursorTheme.name;
          package = resolvePackage config.profile.appearance.cursorTheme.packagePath;
          size = config.profile.appearance.cursorTheme.size;
        };
        font = {
          name = config.profile.appearance.fonts.ui.family;
          size = config.profile.appearance.fonts.ui.size;
        };
        gtk3.bookmarks = [
          "file://${moduleArgs.config.home.homeDirectory}/Documents"
          "file://${moduleArgs.config.home.homeDirectory}/Downloads"
          "file://${moduleArgs.config.home.homeDirectory}/Pictures"
          "file://${moduleArgs.config.home.homeDirectory}/Videos"
          "file://${moduleArgs.config.home.homeDirectory}/Downloads/temp"
          "file://${moduleArgs.config.home.homeDirectory}/Documents/repositories"
        ];
      };

      qt = {
        enable = true;
        platformTheme = {
          name = "qtct";
          package = pkgs.kdePackages.qt6ct;
        };
        style.name = "kvantum";
        qt6ctSettings.Appearance.icon_theme = moduleArgs.config.gtk.iconTheme.name;
      };
    };
}
