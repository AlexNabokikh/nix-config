{...}: let
  waybar = ./../../files/configs/waybar;
in {
  # Install waybar via home-manager module
  programs.waybar.enable = true;

  # Source waybar config from the home-manager store
  home.file = {
    ".config/waybar" = {
      recursive = true;
      source = "${waybar}";
    };
  };
}
