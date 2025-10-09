{
  pkgs,
  ...
}:
{
  xdg = {
    enable = true;

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
