{pkgs, ...}: let
  # Define theme name and configuration for GTK
  catppuccin_name = "Catppuccin-Macchiato-Standard-Lavender-Dark";
  catppuccin = pkgs.catppuccin-gtk.override {
    accents = ["lavender"];
    size = "standard";
    tweaks = ["normal"];
    variant = "macchiato";
  };
in {
  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = catppuccin_name;
      package = catppuccin;
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };
    font = {
      name = "Roboto";
      size = 11;
    };
  };
}
