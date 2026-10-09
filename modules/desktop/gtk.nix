{
  flake.modules.homeManager.gtk =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.profile.appearance.catppuccin) flavor accent;

      gtkTheme = {
        name = "catppuccin-${flavor}-${accent}-compact+normal";
        package = pkgs.catppuccin-gtk.override {
          variant = flavor;
          accents = [ accent ];
          size = "compact";
          tweaks = [ "normal" ];
        };
      };
    in
    {
      catppuccin.gtk.icon.enable = false;

      gtk = {
        enable = true;
        colorScheme = "dark";
        gtk2.enable = false;
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
      };
    };
}
