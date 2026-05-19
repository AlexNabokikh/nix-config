{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
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
          format = "[$symbol$context( $namespace)]($style)";
          contexts = [
            {
              context_pattern = ".*/(?P<cluster>.+)";
              context_alias = "$cluster";
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
        rust = {
          symbol = " ";
        };
        terraform = {
          symbol = " ";
        };
        right_format = "$kubernetes";
      };
    };
  };
}
