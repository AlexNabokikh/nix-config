{
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      settings = {
        inline_height = 25;
        invert = true;
        search_mode = "fuzzy";
      };
      flags = [ "--disable-up-arrow" ];
    };
  };
}
