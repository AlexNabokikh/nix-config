{...}: let
  corectrl = ./../../files/configs/corectrl;
in {
  # Source corectrl config from the home-manager store
  home.file = {
    ".config/corectrl" = {
      recursive = true;
      source = "${corectrl}";
    };
  };
}
