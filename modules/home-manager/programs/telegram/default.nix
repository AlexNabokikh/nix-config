{
  pkgs,
  ...
}:
let
  telegram = pkgs.telegram-desktop;
in
{
  home.packages = [ telegram ];

  xdg.mimeApps.defaultApplicationPackages = [ telegram ];
}
