{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # List of packages installed for the user
  programs.bat = {
    enable = true;
    config.theme = "Catppuccin-macchiato";
  };
}
