{
  flake.modules.homeManager.gtk =
    {
      config,
      ...
    }:
    {
      gtk = {
        enable = true;
        gtk2.enable = false;
        iconTheme = {
          inherit (config.profile.appearance.iconTheme) name package;
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
        };
      };
    };
}
