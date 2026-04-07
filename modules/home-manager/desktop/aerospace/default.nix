{ ... }:
{
  flake.modules.homeManager.desktopAerospace =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.aerospace ];
      home.file.".aerospace.toml".source = ./aerospace.toml;
    };
}
