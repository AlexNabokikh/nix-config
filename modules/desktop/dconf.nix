{
  flake.modules.homeManager.dconf = {
    dconf.settings = {
      "org/gnome/calculator" = {
        accuracy = 9;
        angle-units = "degrees";
        base = 10;
        button-mode = "basic";
        number-format = "automatic";
        show-thousands = false;
        show-zeroes = false;
        source-units = [ "degree" ];
        target-units = [ "radian" ];
        window-maximized = false;
      };

      "org/gnome/desktop/wm/preferences".button-layout = "";

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        search-filter-time-type = "last_modified";
      };

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
