{...}: {
  # Install bat via home-manager module
  programs.bat.enable = true;

  # Set theme via env vars
  home.sessionVariables = {
    BAT_THEME = "Catppuccin-macchiato";
  };
}
