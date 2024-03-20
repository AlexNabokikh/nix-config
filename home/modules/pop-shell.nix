{...}: let
  pop-shell = ./../../files/configs/pop-shell;
in {
  # Source Gnome pop-shell extention config from the home-manager
  home.file = {
    ".config/pop-shell" = {
      recursive = true;
      source = "${pop-shell}";
    };
  };
}
