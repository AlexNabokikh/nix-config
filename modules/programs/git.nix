{
  flake.modules.homeManager.git =
    { config, ... }:
    {
      programs = {
        git = {
          enable = true;
          settings = {
            user = {
              inherit (config.profile) email;
              name = config.profile.fullName;
            };
            pull.rebase = true;
          };
          signing = {
            key = config.profile.gitKey;
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
    };
}
