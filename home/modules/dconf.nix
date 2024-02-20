{...}: {
  # Manage dconf via Home-manager
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "";
      };
      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        search-view = "list-view";
      };
    };
  };
}
