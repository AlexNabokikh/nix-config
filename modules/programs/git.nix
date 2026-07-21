{
  flake.modules.homeManager.git =
    { config, pkgs, ... }:
    let
      pullAll = pkgs.writeShellApplication {
        name = "pull-all";
        runtimeInputs = with pkgs; [
          git
          python3
        ];
        text = ''
          exec python3 ${./scripts/bin/pull-all} "$@"
        '';
      };
    in
    {
      home.packages = [ pullAll ];

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
