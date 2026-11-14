{ lib, pkgs, ... }:
let
  docker = pkgs.writeShellScriptBin "docker" ''
    exec ${lib.getExe pkgs.podman} "$@"
  '';
in
{
  home.packages =
    with pkgs;
    [
      podman-compose
      podman-tui
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      docker
      podman
    ];

  programs.zsh.shellAliases.pt = "podman-tui";
}
