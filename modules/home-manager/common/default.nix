{ ... }:
{
  flake.modules.homeManager.common =
    {
      lib,
      pkgs,
      ...
    }:
    {
      # Nicely reload system units when changing configs
      systemd.user.startServices = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) "sd-switch";

      # Ensure common packages are installed
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
          pipenv
          podman-compose
          podman-tui
          python3
          ripgrep
          opentofu
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

      # Catppuccin flavor and accent
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "lavender";
      };
    };
}
