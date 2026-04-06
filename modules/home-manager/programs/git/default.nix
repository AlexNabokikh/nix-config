{ ... }:
{
  flake.modules.homeManager.programsGit =
    { config, ... }:
    {
      # Install git via home-manager module
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
    };
}
