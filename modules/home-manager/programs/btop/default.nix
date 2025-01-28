{...}: {
  # Install btop via home-manager module
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  # Enable catppuccin theming for btop.
  catppuccin.btop.enable = true;
}
