{...}: {
  # Install bat via home-manager module
  programs.bat = {
    enable = true;
  };

  # Enable catppuccin theming for bat.
  catppuccin.bat.enable = true;
}
