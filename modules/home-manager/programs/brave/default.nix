{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Ensure Brave browser package installed
  home.packages = [ pkgs.brave ];

  xdg = lib.mkIf (!pkgs.stdenv.isDarwin) {
    mimeApps = {
      defaultApplications = lib.mkMerge [
        (config.lib.xdg.mimeAssociations [ pkgs.brave ])
      ];

    };
  };
}
