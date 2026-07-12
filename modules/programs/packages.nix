{
  flake.modules.homeManager.packages =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages =
        with pkgs;
        [
          awscli2
          brave
          dig
          eza
          fd
          jq
          nh
          nodejs
          openconnect
          opentofu
          pipenv
          podman-compose
          podman-tui
          python3
          ripgrep
          telegram-desktop
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          anki-bin
          mos
          podman
          raycast
        ]
        ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
          anki
          gcc
          gnumake
          killall
          (tesseract.override {
            enableLanguages = [
              "eng"
              "pol"
              "rus"
            ];
          })
          unzip
          wl-clipboard
        ];
    };
}
