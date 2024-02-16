{pkgs, ...}: let
  swaync = ./../../files/configs/swaync;
in {
  # Install swaync via home-manager package
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  # Source swaync config from the home-manager store
  home.file = {
    ".config/swaync" = {
      recursive = true;
      source = "${swaync}";
    };
  };
}
