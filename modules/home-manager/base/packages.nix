{ ... }:
{
  flake.modules.homeManager.packages =
    {
      lib,
      pkgs,
      ...
    }:
    {
      systemd.user.startServices = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) "sd-switch";

      home.packages =
        with pkgs;
        [
          awscli2
          dig
          eza
          fd
          github-copilot-cli
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
          tesseract
          unzip
          wl-clipboard
        ];
    };
}
