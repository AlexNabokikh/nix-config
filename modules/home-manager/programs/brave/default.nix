{ pkgs, lib, ... }:
{
  # Ensure Brave browser package installed
  home.packages = [ pkgs.brave ];

  xdg = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = lib.xdg.mimeAssociations [ pkgs.brave ];
    };
  };
}
