{
  flake.modules.homeManager.programsGit =
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
            signByDefault = true;
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            keep-plus-minus-markers = true;
            light = false;
            line-numbers = true;
            navigate = true;
            width = 280;
          };
        };

        lazygit = {
          enable = true;

          settings = {
            git = {
              pager = {
                colorArg = "always";
                pager = "delta --color-only --dark --paging=never";
              };
            };
          };
        };
      };
    };
}
