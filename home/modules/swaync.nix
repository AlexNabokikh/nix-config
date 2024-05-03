{pkgs, ...}: let
  swaync_config = ./../../files/configs/swaync;
in {
  # Install swaync via home-manager package
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  # Source swaync config from the home-manager store
  xdg.configFile = {
    "swaync" = {
      recursive = true;
      source = "${swaync_config}";
    };
  };
}
