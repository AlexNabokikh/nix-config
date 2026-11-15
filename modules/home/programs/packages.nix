{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      dig
      fd
      jq
      nh
      nodejs
      openconnect
      pipenv
      python3
      ripgrep
      (
        if stdenv.hostPlatform.isDarwin then
          telegram-desktop.override {
            unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: {
              # Remove once nixpkgs includes the fix from PR #586511.
              postPatch = (old.postPatch or "") + ''
                substituteInPlace Telegram/cmake/telegram_apple_swift_runtime.cmake \
                  --replace-fail 'COMMAND "''${swift_bin_dir}/swift-stdlib-tool"' \
                                 'COMMAND true'
              '';
            });
          }
        else
          telegram-desktop
      )
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      anki-bin
      mos
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      anki
      gcc
      gnumake
      unzip
      wl-clipboard
    ];
}
