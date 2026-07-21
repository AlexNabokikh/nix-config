{
  flake.modules.homeManager.dconf = {
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
