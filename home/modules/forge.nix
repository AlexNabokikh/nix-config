{...}: let
  forge = ./../../files/configs/forge;
in {
  # Source Gnome Forge extention config from the home-manager
  home.file = {
    ".config/forge" = {
      recursive = true;
      source = "${forge}";
    };
  };
}
