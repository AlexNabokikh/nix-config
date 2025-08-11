{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;

      defaultApplications = lib.mkMerge [
        (config.lib.xdg.mimeAssociations [ pkgs.gnome-text-editor ])
        (config.lib.xdg.mimeAssociations [ pkgs.loupe ])
        (config.lib.xdg.mimeAssociations [ pkgs.totem ])
      ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
