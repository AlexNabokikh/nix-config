{
  flake.modules.homeManager.gpg =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.gpg = {
        enable = true;
        settings = {
          personal-cipher-preferences = "AES256";
          personal-digest-preferences = "SHA512";
          default-preference-list = "SHA512 AES256 ZLIB BZIP2 ZIP Uncompressed";
          charset = "utf-8";
          no-greeting = true;
          with-key-origin = true;
          throw-keyids = true;
        };
      };

      services.gpg-agent = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
        enable = true;
        enableSshSupport = true;
        pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
      };
    };
}
