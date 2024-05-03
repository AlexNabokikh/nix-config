{...}: let
  waybar_config = ./../../files/configs/waybar;
in {
  # Install waybar via home-manager module
  programs.waybar.enable = true;

  # Source waybar config from the home-manager store
  xdg.configFile = {
    "waybar" = {
      recursive = true;
      source = "${waybar_config}";
    };
  };
}
