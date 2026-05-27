{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.modules.nixos.hyprland =
    { config, ... }:
    {
      imports = [ nixos.compositorCommon ];

      home-manager.sharedModules = [
        homeManager.compositorCommon
        homeManager.hyprland
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      # Hyprland's quirk under uwsm. Without it, the cursor in XWayland applications is inconsistent.
      # https://wiki.hypr.land/Configuring/Environment-variables/
      environment.sessionVariables = {
        XCURSOR_SIZE = config.profile.appearance.cursorTheme.size;
        XCURSOR_THEME = config.profile.appearance.cursorTheme.name;
      };
    };

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        configType = "hyprlang";
        systemd.enable = false;

        settings = {
          "$mainMod" = "SUPER";

          input = {
            kb_layout = "pl,ru";
            kb_options = "grp:win_space_toggle";
            repeat_delay = 250;
            repeat_rate = 40;

            follow_mouse = 1;
            mouse_refocus = false;

            touchpad.natural_scroll = true;

            sensitivity = 0;
            accel_profile = "flat";
          };

          cursor.no_warps = true;

          general = {
            border_size = 1;
            "col.active_border" = "$accent";
            "col.inactive_border" = "$surface0";
            gaps_in = 3;
            gaps_out = 6;
            layout = "master";
          };

          decoration = {
            rounding = 8;
            blur = {
              enabled = false;
              size = 3;
              passes = 1;
            };
            shadow = {
              enabled = false;
              range = 4;
              render_power = 3;
            };
          };

          render.direct_scanout = 1;

          animations.enabled = false;

          dwindle = {
            preserve_split = true;
          };

          master = {
            orientation = "left";
            mfact = 0.50;
          };

          gesture = "3, horizontal, workspace";

          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 2;
          };

          windowrule = [
            # Workspace assignments
            "match:class ^(brave-browser)$, workspace 1"
            "match:class ^(Alacritty)$, workspace 2"
            "match:class ^(org\\.telegram\\.desktop)$, workspace 3"
            "match:class ^(steam)$, workspace 4"
            "match:class ^(steam_app_\\d+)$, workspace 5"
            "match:class ^(gnome-pomodoro)$, workspace special"

            # Center all floating windows
            "center on, match:float true"

            # Floating dialogs (sized)
            "match:class ^(xdg-desktop-portal-gtk)$, float on, size (monitor_w*0.4) (monitor_h*0.4)"
            "match:class ^(org.pulseaudio.pavucontrol)$, float on, size (monitor_w*0.5) (monitor_h*0.5)"
            "match:initial_title ^(_crx_.*)$, float on, size (monitor_w*0.15) (monitor_h*0.4)"

            # Floating dialogs (auto-size)
            "match:class ^(gnome-calculator|org\\.gnome\\.Calculator)$, float on"

            # Screen sharing
            "match:title ^(Select what to share)$, float on"
            "match:title ^(.*is sharing (your screen|a window)\\.)$, float on, pin on, border_size 0, move ((monitor_w-window_w)/2) (monitor_h-window_h)"
          ];

          bind = [
            # Layout controls
            "$mainMod, Return, layoutmsg, swapwithmaster"
            "$mainMod, R, layoutmsg, orientationcycle"

            # Window management
            "$mainMod, Q, killactive,"
            "CTRL ALT, Q, exit"
            "$mainMod, F, togglefloating"
            "$mainMod, M, fullscreen, 1 toggle"
            "$mainMod SHIFT, M, fullscreen"

            # Special workspace
            "$mainMod, P, togglespecialworkspace"
            "$mainMod SHIFT, P, movetoworkspacesilent, special"

            # Move focus with mainMod + vim keys
            "$mainMod, l, movefocus, r"
            "$mainMod, h, movefocus, l"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            # Move windows with mainMod + CTRL + vim keys
            "$mainMod CTRL, h, movewindow, l"
            "$mainMod CTRL, j, movewindow, d"
            "$mainMod CTRL, k, movewindow, u"
            "$mainMod CTRL, l, movewindow, r"

            # Resize windows with mainMod + SHIFT + arrow keys
            "$mainMod SHIFT, left, resizeactive, -50 0"
            "$mainMod SHIFT, right, resizeactive, 50 0"
            "$mainMod SHIFT, up, resizeactive, 0 -50"
            "$mainMod SHIFT, down, resizeactive, 0 50"

            # Center focused window
            "CTRL ALT, C, centerwindow"

            # Switch workspaces with mainMod + [1-5]
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"

            # Move active window to a workspace with mainMod + SHIFT + [1-5]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"

            # Launch applications
            "$mainMod SHIFT, Return, exec, alacritty"
            "$mainMod SHIFT, B, exec, brave"
            "$mainMod SHIFT, F, exec, nautilus"
            "$mainMod SHIFT, T, exec, Telegram"
            "CTRL ALT, P, exec, gnome-pomodoro --start-stop"

            # Application launcher
            "CTRL, Space, exec, noctalia-shell ipc call launcher toggle"

            # Clipboard history
            "ALT SHIFT, V, exec, noctalia-shell ipc call launcher clipboard"

            # Pick color from screen and copy to clipboard
            "$mainMod SHIFT, C, exec, hyprpicker -a"

            # OCR
            "ALT SHIFT, 2, exec, ocr"

            # Screenshot area
            "$mainMod SHIFT, S, exec, wayblast area | swappy -f -"

            # Screenshot entire screen
            "$mainMod CTRL, S, exec, wayblast fullscreen | swappy -f -"

            # Screen recording
            "$mainMod SHIFT, R, exec, toggle-screen-recording"

            # Lock screen
            "CTRL ALT, L, exec, noctalia-shell ipc call lockScreen lock"

            # Toggle control center panel
            "$mainMod, C, exec, noctalia-shell ipc call controlCenter toggle"

            # Open notifications history
            "$mainMod, N, exec, noctalia-shell ipc call notifications toggleHistory"

            # Clear all notifications
            "$mainMod SHIFT, Backspace, exec, noctalia-shell ipc call notifications clear"

            # Adjust brightness
            ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
            ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"

            # Adjust volume
            ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
            ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
            ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"

            # Adjust mic sensitivity
            "SHIFT, XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increaseInput"
            "SHIFT, XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decreaseInput"
            "SHIFT, XF86AudioMute, exec, noctalia-shell ipc call volume muteInput"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
      };

      xdg = {
        desktopEntries = {
          quit-all-applications = {
            name = "Quit All Applications";
            exec = ''${pkgs.bash}/bin/bash -lc "hyprctl -j clients | jq -r '.[].address' | xargs -r -I {} hyprctl dispatch closewindow address:{}"'';
            icon = "system-log-out";
          };

          uuctl = {
            name = "uuctl";
            noDisplay = true;
          };
        };

        configFile = {
          "hypr/xdph.conf".text = ''
            screencopy {
              allow_token_by_default = true
              max_fps = 60
            }
          '';
        };
      };
    };
}
