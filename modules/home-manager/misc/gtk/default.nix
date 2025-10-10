{
  config,
  pkgs,
  ...
}:
{
  # GTK theme configuration
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "catppuccin-macchiato-lavender-compact";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        variant = "macchiato";
        size = "compact";
      };
    };
    iconTheme = {
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
}
