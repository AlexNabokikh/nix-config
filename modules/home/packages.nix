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
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      anki-bin
      docker
      mos
      podman
      (telegram-desktop.override {
        unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: {
          # Remove once nixpkgs includes the fix from PR #586511.
          postPatch = (old.postPatch or "") + ''
            substituteInPlace Telegram/cmake/telegram_apple_swift_runtime.cmake \
              --replace-fail 'COMMAND "''${swift_bin_dir}/swift-stdlib-tool"' \
                             'COMMAND true'
          '';
        });
      })
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
