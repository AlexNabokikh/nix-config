{
  lib,
  pkgs,
  ...
}:
let
  # On NixOS, the podman service and docker alias come from modules/nixos/base.nix.
  docker = pkgs.writeShellScriptBin "docker" ''
    exec ${lib.getExe pkgs.podman} "$@"
  '';
in
{
  programs.granted.enable = true;

  home.packages =
    with pkgs;
    [
      awscli2
      brave
      dig
      fd
      go
      jq
      nh
      nodejs
      openconnect
      opentofu
      pipenv
      podman-compose
      python3
      ripgrep
      telegram-desktop
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      anki-bin
      docker
      mos
      podman
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      anki
      gcc
      gnumake
      telegram-desktop
      unzip
      wl-clipboard
    ];
}
