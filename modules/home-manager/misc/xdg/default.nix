{ lib, pkgs, ... }:
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;

      defaultApplications = lib.mkMerge [
        (lib.xdg.mimeAssociations [ pkgs.gnome.gnome-text-editor ])
        (lib.xdg.mimeAssociations [ pkgs.gnome.loupe ])
        (lib.xdg.mimeAssociations [ pkgs.gnome.totem ])
      ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
