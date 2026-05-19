{
  flake.modules.homeManager.gtk =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      gtkTheme = {
        name = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-compact";
        package = pkgs.catppuccin-gtk.override {
          accents = [ config.catppuccin.accent ];
          variant = config.catppuccin.flavor;
          size = "compact";
        };
      };
    in
    {
      gtk = {
        enable = true;
        colorScheme = "dark";
        gtk2.force = true;
        gtk4.theme = gtkTheme;
        theme = gtkTheme;
        iconTheme = lib.mkForce {
          inherit (config.profile.appearance.iconTheme) name;
          inherit (config.profile.appearance.iconTheme) package;
        };
        font = {
          name = config.profile.appearance.fonts.ui.family;
          inherit (config.profile.appearance.fonts.ui) size;
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
    };
}
