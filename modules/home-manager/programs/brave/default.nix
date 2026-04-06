{ ... }:
{
  flake.modules.homeManager.programsBrave =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.brave ];

      xdg.mimeApps.defaultApplicationPackages = [ pkgs.brave ];
    };
}
