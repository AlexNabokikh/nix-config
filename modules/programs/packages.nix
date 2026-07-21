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
          jq
          openconnect
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
