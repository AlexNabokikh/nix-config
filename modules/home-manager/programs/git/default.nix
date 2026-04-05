{ config, ... }:
let
  inherit (config) userInfo;
in
{
  flake.modules.homeManager.programsGit =
    { ... }:
    {
      # Install git via home-manager module
      programs.git = {
        enable = true;
        settings = {
          user = {
            email = userInfo.email;
            name = userInfo.fullName;
          };
          pull.rebase = true;
        };
        signing = {
          key = userInfo.gitKey;
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
