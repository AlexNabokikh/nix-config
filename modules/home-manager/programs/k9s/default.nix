{...}: {
  # Install k9s via home-manager module
  programs.k9s.enable = true;

  # Enable catppuccin theming for k9s
  catppuccin.k9s.enable = true;
}
