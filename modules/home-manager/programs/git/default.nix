{ ... }:
{
  flake.modules.homeManager.programsGit =
    { config, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            email = config.profile.email;
            name = config.profile.fullName;
          };
          pull.rebase = true;
        };
        signing = {
          key = config.profile.gitKey;
          signByDefault = true;
        };
      };

      programs.delta = {
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

      programs.lazygit = {
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
}
