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

      wallpaperDir = "${config.home.homeDirectory}/Documents/repositories/nix-config/modules/profile";
      wallpaperPath = "${wallpaperDir}/wallpaper.jpg";
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        customPalettes."catppuccin-custom" = catppuccinPalette;

        settings = {
          shell = {
            avatar_path = "/var/lib/AccountsService/icons/${config.home.username}";
            font_family = uiFont;
            show_location = false;

            animation.enabled = false;

            panel = {
              launcher_categories = false;
              launcher_session_search = true;
            };

            screenshot = {
              pipe_command = "swappy -f -";
              pipe_to_command = true;
              save_to_file = false;
            };
          };

          theme = {
            source = "custom";
            builtin = "Catppuccin";
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

          lockscreen_widgets = {
            enabled = false;
            schema_version = 2;
            widget_order = [ "lockscreen-login-box@DP-1" ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget."lockscreen-login-box@DP-1" = {
              type = "login_box";
              output = "DP-1";
              box_height = 0.0;
              box_width = 0.0;
              cx = 1280.0;
              cy = 1317.0;
              rotation = 0.0;
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                input_opacity = 1.0;
                input_radius = 6.0;
                show_login_button = true;
              };
            };
          };

          keybinds = {
            down = [ "Ctrl+j" ];
            up = [ "Ctrl+k" ];
          };

          wallpaper = {
            directory = wallpaperDir;
            default.path = wallpaperPath;
            last.path = wallpaperPath;
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
            { type = "session"; }
          ];
        };
      };
    };
}
