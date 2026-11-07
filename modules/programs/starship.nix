{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format =
          "$username$hostname$directory"
          + "$git_branch$git_commit$git_state$git_status"
          + "$nix_shell$cmd_duration"
          + "$line_break$jobs$status$character";
        aws = {
          disabled = true;
        };
        kubernetes = {
          disabled = false;
          symbol = "󱃾 ";
          format = "[$symbol$context( $namespace)]($style)";
          contexts = [
            {
              context_pattern = ".*/(?P<cluster>.+)";
              context_alias = "$cluster";
            }
          ];
        };
        right_format = "$kubernetes";
      };
    };
  };
}
