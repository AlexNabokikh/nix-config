{...}: let
  wallpaper = ./../../files/wallpapers/wallpaper.jpg;
  hyprland = ./../../files/configs/hypr;
in {
  imports = [
    ./clipboard.nix
    ./gtklock.nix
    ./kanshi.nix
    ./swappy.nix
    ./swaync.nix
    ./waybar.nix
    ./wofi.nix
    ./xdg.nix
  ];
  # Source hyprland config from the home-manager store
  home.file = {
    ".config/hypr" = {
      recursive = true;
      source = "${hyprland}";
    };
    ".config/hypr/hyprpaper.conf".text = ''
      splash = false
      preload = ${wallpaper}
      wallpaper = DP-1, ${wallpaper}
      wallpaper = eDP-1, ${wallpaper}
    '';
    ".config/hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof gtklock || gtklock -i -S
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }
    '';
  };
}
