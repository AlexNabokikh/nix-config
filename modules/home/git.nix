{
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  stylix.targets.lazygit.enable = true;

  services.gpg-agent = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  programs = {
    gpg.enable = true;

    git = {
      enable = true;
      settings = {
        user = {
          inherit (osConfig.user) email;
          name = osConfig.user.fullName;
        };
        pull.rebase = true;
      };
      signing = {
        key = osConfig.user.gitKey;
        format = "openpgp";
        signByDefault = true;
      };
    };

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
            type = "stdinFilter";
            colorArg = "always";
            command = "diff-so-fancy";
          }
        ];
      };
    };
  };
}
