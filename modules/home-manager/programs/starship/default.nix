{...}: {
  # Starship configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      directory = {
        style = "bold lavender";
      };
      aws = {
        disabled = true;
      };
      docker_context = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      kubernetes = {
        disabled = false;
        style = "bold pink";
        symbol = "󱃾 ";
        format = "[$symbol$context( \($namespace\))]($style)";
        contexts = [
          {
            context_pattern = "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)";
            context_alias = "$var_cluster";
          }
        ];
      };
      helm = {
        symbol = " ";
      };
      gradle = {
        symbol = " ";
      };
      java = {
        symbol = " ";
      };
      kotlin = {
        symbol = " ";
      };
      lua = {
        symbol = " ";
      };
      package = {
        symbol = " ";
      };
      php = {
        symbol = " ";
      };
      python = {
        symbol = " ";
      };
      terraform = {
        symbol = " ";
      };
      right_format = "$kubernetes";
    };
  };

  # Enable catppuccin theming for starship.
  catppuccin.starship.enable = true;
}
