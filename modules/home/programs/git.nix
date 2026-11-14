{ osConfig, ... }:
{
  stylix.targets.lazygit.enable = true;

  programs = {
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
