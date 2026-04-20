{
  flake.modules.homeManager.scripts =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.file = {
        ".local/bin" = {
          recursive = true;
          source = ./bin;
        };
      };

      home.sessionPath = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [ "$HOME/.local/bin" ];
    };
}
