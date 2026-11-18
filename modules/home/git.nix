{ lib, pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Alexander Nabokikh";
          email = "alexander.nabokikh@olx.pl";
        };
        pull.rebase = true;
      };
      signing = {
        key = "C5810093";
        format = "openpgp";
        signByDefault = true;
      };
    };

    gpg.enable = true;

    diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };

    lazygit = {
      enable = true;
      settings = {
        gui.showNumstatInFilesView = true;
        git.diffRenderers = [
          {
            colorArg = "always";
            command = "diff-so-fancy";
          }
        ];
      };
    };
  };

  services.gpg-agent = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
