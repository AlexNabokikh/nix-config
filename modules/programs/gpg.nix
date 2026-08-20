{
  flake.modules.homeManager.gpg =
    { pkgs, lib, ... }:
    {
      programs.gpg.enable = true;

      services.gpg-agent = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = true;
        pinentry.package = pkgs.pinentry-gnome3;
      };
    };
}
