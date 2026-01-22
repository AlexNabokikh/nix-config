{
  pkgs,
  ...
}:
{
  # Ensure Brave browser package installed
  home.packages = [ pkgs.brave ];

  xdg.mimeApps.defaultApplicationPackages = [ pkgs.brave ];
}
