{ pkgs, ... }:
{
  # Install swaync via home-manager module

  # temp switch to stable swaync: https://github.com/catppuccin/swaync/issues/20
  home.packages = [
    pkgs.stable.swaynotificationcenter
  ];

  # Source swaync config from the home-manager store
  xdg.configFile = {
    "swaync/style.css" = {
      source = ./style.css;
    };
  };
}
