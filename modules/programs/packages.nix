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
          dig
          fd
          jq
          nh
          nodejs
          openconnect
          python3
          ripgrep
          telegram-desktop
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          anki-bin
          raycast
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          anki
          gcc
          gnumake
          unzip
        ];
    };
}
