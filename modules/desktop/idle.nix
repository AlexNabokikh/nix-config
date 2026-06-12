{
  flake.modules.homeManager.idle = {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "noctalia msg session lock";
          after_sleep_cmd = "pidof Hyprland >/dev/null && hyprctl dispatch dpms on || niri msg action power-on-monitors";
          lock_cmd = "noctalia msg session lock";
        };
      };
    };
  };
}
