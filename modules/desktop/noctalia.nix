{
  flake.modules.homeManager.noctalia =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin;
    in
    {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          shell = {
            avatar_path = config.profile.avatar;
            font_family = config.profile.appearance.fonts.ui.family;
            launch_apps_as_systemd_services = true;
            polkit_agent = true;
            setup_wizard_enabled = false;
            show_location = false;

            animation.enabled = false;

            launcher = {
              categories = false;
              fetch_exchange_rates = false;

              sort_by_usage = false;
              providers.session.global = true;
            };
          };

          theme = {
            source = "community";
            community_palette = "Catppuccin ${lib.toSentenceCase catppuccin.flavor} ${lib.toSentenceCase catppuccin.accent}";
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
            custom_schedule = true;
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
