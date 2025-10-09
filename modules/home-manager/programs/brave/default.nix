{
  pkgs,
  ...
}:
let
  brave = pkgs.brave;
in
{
  # Ensure Brave browser package installed
  home.packages = [ brave ];

  xdg.mimeApps.defaultApplicationPackages = [ brave ];
}
