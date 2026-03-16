{ hmModules, ... }:
{
  imports = [
    "${hmModules}/desktop/wayland-common"
  ];

  xdg.configFile = {
    "niri/config.kdl" = {
      source = ./config.kdl;
    };
  };
}
