{ ... }:
{
  # Manage Hypridle service via Home-manager
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
        after_sleep_cmd = "pidof Hyprland >/dev/null && hyprctl dispatch dpms on || niri msg action power-on-monitors";
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
      };
    };
  };
}
