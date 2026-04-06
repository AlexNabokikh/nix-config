{ ... }:
{
  flake.modules.homeManager.desktopCompositorTheming =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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
        gtk4.theme = config.gtk.theme;
        theme = {
          name = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-compact";
          package = pkgs.catppuccin-gtk.override {
            accents = [ config.catppuccin.accent ];
            variant = config.catppuccin.flavor;
            size = "compact";
          };
        };
        iconTheme = lib.mkForce {
          name = config.profile.appearance.iconTheme.name;
          package = config.profile.appearance.iconTheme.package;
        };
        cursorTheme = {
          name = config.profile.appearance.cursorTheme.name;
          package = config.profile.appearance.cursorTheme.package;
          size = config.profile.appearance.cursorTheme.size;
        };
        font = {
          name = config.profile.appearance.fonts.ui.family;
          size = config.profile.appearance.fonts.ui.size;
        };
        gtk3.bookmarks = [
          "file://${config.home.homeDirectory}/Documents"
          "file://${config.home.homeDirectory}/Downloads"
          "file://${config.home.homeDirectory}/Pictures"
          "file://${config.home.homeDirectory}/Videos"
          "file://${config.home.homeDirectory}/Downloads/temp"
          "file://${config.home.homeDirectory}/Documents/repositories"
        ];
      };

      qt = {
        enable = true;
        platformTheme = {
          name = "qtct";
          package = pkgs.kdePackages.qt6ct;
        };
        style.name = "kvantum";
        qt6ctSettings.Appearance.icon_theme = config.gtk.iconTheme.name;
      };
    };
}
