{
  stylix.targets.lazygit.enable = true;

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
