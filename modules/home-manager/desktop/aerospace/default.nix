{ ... }:
{
  flake.modules.homeManager.programsAerospace =
    {
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        home.packages = [ pkgs.aerospace ];
        home.file.".aerospace.toml".source = ./aerospace.toml;
      };
    };
}
