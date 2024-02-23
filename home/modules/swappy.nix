{...}: let
  swappy = ./../../files/configs/swappy;
in {
  # Source swappy config from the home-manager store
  home.file = {
    ".config/swappy" = {
      recursive = true;
      source = "${swappy}";
    };
  };
}
