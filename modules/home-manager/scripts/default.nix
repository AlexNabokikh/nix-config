{
  pkgs,
  lib,
  ...
}: {
  # Source scripts from the home-manager store
  home.file = {
    ".local/bin" = {
      recursive = true;
      source = ./bin;
    };
  };

  # Conditional configuration for Darwin systems
  home.sessionPath = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isDarwin [
      "$HOME/.local/bin"
    ])
  ];
}
