{
  userConfig,
  pkgs,
  ...
}: {
  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark-Compact-Macchiato";
      package = pkgs.magnetic-catppuccin-gtk.override {
        shade = "dark";
        size = "compact";
        tweaks = ["macchiato"];
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
        "file:///home/${userConfig.name}/Documents"
        "file:///home/${userConfig.name}/Downloads"
        "file:///home/${userConfig.name}/Pictures"
        "file:///home/${userConfig.name}/Videos"
        "file:///home/${userConfig.name}/Downloads/temp"
        "file:///home/${userConfig.name}/Documents/repositories"
      ];
    };
  };
}
