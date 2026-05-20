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
          claude-code
          dig
          eza
          fd
          jq
          nh
          nodejs
          opencode
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
          colima
          hidden-bar
          mos
          podman
          raycast
        ]
        ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
          anki
          gcc
          gnumake
          killall
          tesseract
          unzip
          wl-clipboard
        ];
    };
}
