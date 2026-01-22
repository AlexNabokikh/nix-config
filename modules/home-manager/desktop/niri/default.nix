{ nhModules, ... }:
{
  imports = [
    "${nhModules}/desktop/wayland-common"
  ];

  xdg.configFile = {
    "niri/config.kdl" = {
      source = ./config.kdl;
    };
  };
}
