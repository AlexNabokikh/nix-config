{ ... }:
{
  # Manage Hypridle service via Home-manager
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
      };
    };
  };
}
