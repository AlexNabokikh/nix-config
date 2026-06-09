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
            signByDefault = true;
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            keep-plus-minus-markers = true;
            line-numbers = true;
            navigate = true;
            width = 280;
          };
        };

        lazygit = {
          enable = true;

          settings = {
            gui = {
              showNumstatInFilesView = true;
            };

            git = {
              pagers = [
                {
                  colorArg = "always";
                  pager = "delta --paging=never";
                }
              ];
            };
          };
        };
      };
    };
}
