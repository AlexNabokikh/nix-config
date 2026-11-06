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

        difftastic = {
          enable = true;
          git.enable = true;
          options = {
            background = "dark";
            color = "always";
          };
        };

        lazygit = {
          enable = true;

          settings = {
            gui.showNumstatInFilesView = true;

            git.diffRenderers = [
              {
                type = "extDiff";
                command = "difft --color=always --display=inline";
              }
            ];
          };
        };
      };
    };
}
