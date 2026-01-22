{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.telegram-desktop ];

  xdg.mimeApps.defaultApplicationPackages = [ pkgs.telegram-desktop ];
}
