{...}: {
  # Install atuin via home-manager module
  programs.atuin = {
    enable = true;
    settings = {
      inline_height = 25;
      invert = true;
      records = true;
      search_mode = "skim";
      secrets_filter = true;
      style = "compact";
    };
    flags = ["--disable-up-arrow"];
  };
}
