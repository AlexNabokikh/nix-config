{...}: {
  # Install btop via home-manager module
  programs.btop = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      vim_keys = true;
    };
  };
}
