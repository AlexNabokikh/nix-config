{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.telegram-desktop ];

  xdg = lib.mkIf (!pkgs.stdenv.isDarwin) {
    mimeApps = {
      defaultApplications = lib.xdg.mimeAssociations [ pkgs.telegram-desktop ];
    };
  };
}
