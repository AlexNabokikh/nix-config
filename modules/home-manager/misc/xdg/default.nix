{
  pkgs,
  ...
}:
{
  xdg = {
    enable = true;

    # Hide the following desktop entries for launcher.
    desktopEntries = {
      uuctl = {
        name = "uuctl";
        noDisplay = true;
      };
      qt6ct = {
        name = "qt6ct";
        noDisplay = true;
      };
      kvantummanager = {
        name = "kvantum";
        noDisplay = true;
      };
    };

    mimeApps = {
      enable = true;
      defaultApplicationPackages = [
        pkgs.gnome-text-editor
        pkgs.loupe
        pkgs.totem
      ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
