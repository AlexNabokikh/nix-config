{...}: let
  wallpaper = ./../../files/wallpapers/wallpaper.jpg;
  lock = ./../../files/wallpapers/wallpaper-lock.png;
  hyprland = ./../../files/configs/hypr;
in {
  imports = [
    ./clipboard.nix
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
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }
    '';

    ".config/hypr/hyprlock.conf".text = ''
      background {
          monitor =
          path = ${lock}
          blur_passes = 3
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
      }

      general {
          no_fade_in = false
          grace = 0
          disable_loading_bar = true
      }

      input-field {
          monitor =
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(0, 0, 0, 0.5)
          font_color = rgb(200, 200, 200)
          fade_on_empty = false
          capslock_color = -1
          font_family = JetBrains Mono Nerd Font Mono
          placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
          hide_input = false
          position = 0, -120
          halign = center
          valign = center
      }

      # Time
      label {
          monitor =
          text = cmd[update:1000] date +"%-I:%M%p"
          color = $foreground
          #color = rgba(255, 255, 255, 0.6)
          font_size = 120
          font_family = JetBrains Mono Nerd Font Mono ExtraBold
          position = 0, -300
          halign = center
          valign = top
      }

      # User
      label {
          monitor =
          text = $USER
          color = $foreground
          #color = rgba(255, 255, 255, 0.6)
          font_size = 25
          font_family = JetBrains Mono Nerd Font Mono
          position = 0, -40
          halign = center
          valign = center
      }

      # Keyboard layout
      label {
        text = cmd[update:200] hyprctl devices -j | jq -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap'
        color = rgba(129, 162, 190, 1.0)
        font_size = 10
        font_family = JetBrains Mono Nerd Font Mono
        position = 0, -90
        halign = center
        valign = center
      }
    '';
  };
}
