{...}: let
  corectrl_config = ./../../files/configs/corectrl;
in {
  # Source corectrl config from the home-manager store
  xdg.configFile = {
    "corectrl" = {
      recursive = true;
      source = "${corectrl_config}";
    };
  };
}
