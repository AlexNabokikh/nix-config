{ ... }:
{
  flake.modules.homeManager.appearanceTheming =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Catppuccin flavor and accent
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "lavender";
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
          name = "Tela-circle-dark";
          package = pkgs.tela-circle-icon-theme;
        };
        cursorTheme = {
          name = "Yaru";
          package = pkgs.yaru-theme;
          size = 24;
        };
        font = {
          name = "Roboto";
          size = 11;
        };
        gtk3 = {
          bookmarks = [
            "file://${config.home.homeDirectory}/Documents"
            "file://${config.home.homeDirectory}/Downloads"
            "file://${config.home.homeDirectory}/Pictures"
            "file://${config.home.homeDirectory}/Videos"
            "file://${config.home.homeDirectory}/Downloads/temp"
            "file://${config.home.homeDirectory}/Documents/repositories"
          ];
        };
      };

      # Qt theme configuration
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
    };
}
