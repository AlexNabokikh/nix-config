{...}: let
  waybar = ./../../files/configs/waybar;
in {
  # Source waybar config from the home-manager store
  home.file = {
    ".config/waybar" = {
      recursive = true;
      source = "${waybar}";
    };
  };
}
