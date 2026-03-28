# Module: Atuin Shell History
# Purpose: Configures Atuin for enhanced shell history with sync capabilities
# Platform: All
_: {
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
    flags = [];
  };
}
