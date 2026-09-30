{
  flake.modules.homeManager.gtk =
    {
      config,
      pkgs,
      catppuccinColor,
      ...
    }:
    let
      colloidTheme = pkgs.callPackage ./_colloid-theme.nix {
        inherit (config.profile.appearance.catppuccin) flavor accent;
        inherit catppuccinColor;
      };
      gtkTheme = { inherit (colloidTheme) name package; };
    in
    {
      catppuccin.gtk.icon.enable = false;

      gtk = {
        enable = true;
        colorScheme = "dark";
        gtk2.force = true;
        gtk4.theme = gtkTheme;
        theme = gtkTheme;
        iconTheme = {
          inherit (config.profile.appearance.iconTheme) name package;
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
        ];
      };

      dconf.settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "";

        "org/gtk/gtk4/settings/file-chooser" = {
          show-hidden = true;
          view-type = "list";
        };

        "org/gtk/settings/file-chooser" = {
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = true;
          show-size-column = true;
          show-type-column = true;
          sort-column = "name";
          sort-directories-first = true;
          sort-order = "ascending";
          type-format = "category";
        };
      };
    };
}
