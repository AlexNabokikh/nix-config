{ nhModules, ... }:
{
  imports = [
    "${nhModules}/desktop/wayland-common"
  ];

  # Source hyprland config from the home-manager store
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      source = ./hyprland.conf;
    };

    "hypr/xdph.conf".text = ''
      screencopy {
        allow_token_by_default = true
        max_fps = 60
      }
    '';
  };
}
