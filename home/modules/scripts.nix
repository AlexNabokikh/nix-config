{
  pkgs,
  lib,
  ...
}: let
  scripts = ./../../files/scripts;
in {
  # Source scripts from the home-manager store
  home.file = {
    ".local/bin" = {
      recursive = true;
      source = "${scripts}";
    };
  };

  # Conditional configuration for Darwin systems
  home.sessionPath = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isDarwin [
      "$HOME/.local/bin"
    ])
  ];
}
