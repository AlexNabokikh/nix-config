{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
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
        rust = {
          symbol = " ";
        };
        right_format = "$kubernetes";
      };
    };
  };
}
