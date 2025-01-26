{...}: {
  # Install swaync via home-manager module
  services.swaync = {
    enable = true;
  };

  # Source swaync config from the home-manager store
  xdg.configFile = {
    "swaync" = {
      recursive = true;
      source = ./style.css;
    };
  };
}
