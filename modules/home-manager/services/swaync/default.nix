{ pkgs, ... }:
{
  # Install swaync via home-manager module

  # temp switch to stable swaync: https://github.com/catppuccin/swaync/issues/20
  home.packages = [ pkgs.swaynotificationcenter ];

  # Source swaync config from the home-manager store
  xdg.configFile = {
    "swaync/config.json".text = ''
      {
        "notification-body-image-height": 100,
        "notification-body-image-width": 200,
        "notification-icon-size": 32
      }
    '';

    "swaync/style.css" = {
      source = ./style.css;
    };
  };
}
