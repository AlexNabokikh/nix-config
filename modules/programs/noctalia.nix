{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    {
      config,
      catppuccinColor,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin;
      uiFont = config.profile.appearance.fonts.ui.family;

      color = catppuccinColor;
      accentColor = color catppuccin.accent;

      catppuccinPalette = {
        dark = {
          mPrimary = accentColor;
          mOnPrimary = color "crust";
          mSecondary = color "pink";
          mOnSecondary = color "crust";
          mTertiary = color "mauve";
          mOnTertiary = color "crust";
          mError = color "red";
          mOnError = color "crust";
          mSurface = color "base";
          mOnSurface = color "text";
          mSurfaceVariant = color "surface0";
          mOnSurfaceVariant = color "subtext0";
          mOutline = color "overlay0";
          mShadow = color "crust";
          mHover = accentColor;
          mOnHover = color "crust";
          terminal = {
            background = color "base";
            foreground = color "text";
            cursor = color "rosewater";
            cursorText = color "base";
            selectionBg = color "surface2";
            selectionFg = color "text";
            normal = {
              black = color "surface1";
              red = color "red";
              green = color "green";
              yellow = color "yellow";
              blue = color "blue";
              magenta = color "pink";
              cyan = color "teal";
              white = color "subtext1";
            };
            bright = {
              black = color "surface2";
              red = color "red";
              green = color "green";
              yellow = color "yellow";
              blue = color "blue";
              magenta = color "pink";
              cyan = color "teal";
              white = color "subtext0";
            };
          };
        };
      };
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        customPalettes."catppuccin-custom" = catppuccinPalette;

        settings = {
          shell = {
            font_family = uiFont;
            show_location = false;

            animation.enabled = false;

            launcher = {
              categories = false;
              session_search = true;
            };

            screenshot = {
              pipe_command = "swappy -f -";
              pipe_to_command = true;
              save_to_file = false;
            };
          };

          theme = {
            source = "custom";
            custom_palette = "catppuccin-custom";
            templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
            };
          };

          backdrop.enabled = true;

          notification = {
            show_actions = false;
            show_app_name = false;
          };

          osd = {
            position = "top_right";
            kinds.keyboard_layout = false;
          };

          nightlight.enabled = true;

          weather.enabled = false;

          location = {
            sunrise = "06:00";
            sunset = "20:00";
          };

          system.monitor.enabled = false;

          desktop_widgets.enabled = false;

          lockscreen_widgets.enabled = false;

          idle = {
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];
            pre_action_fade_seconds = 0;

            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 600;
              };

              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 900;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 660;
              };
            };
          };

          keybinds = {
            down = [ "Ctrl+j" ];
            up = [ "Ctrl+k" ];
          };

          wallpaper = {
            default.path = config.profile.wallpaper;
          };

          bar.default = {
            start = [ "workspaces" ];
            end = [
              "tray"
              "keyboard_layout"
              "network"
              "volume"
              "battery"
              "notifications"
            ];
            margin_edge = 0;
            margin_ends = 0;
            padding = 6;
            radius = 0;
            shadow = false;
            widget_spacing = 12;
          };

          widget = {
            battery = {
              display_mode = "graphic";
              scale = 0.8;
              show_label = false;
            };
            clock.format = "{:%H:%M %a, %b %d}";
            network.show_label = false;
            tray.drawer = true;
            volume.show_label = false;
            workspaces.hide_when_empty = true;
          };

          control_center.shortcuts = [
            { type = "wifi"; }
            { type = "bluetooth"; }
            { type = "nightlight"; }
            { type = "notification"; }
            { type = "power_profile"; }
            { type = "caffeine"; }
          ];
        };
      };
    };
}
