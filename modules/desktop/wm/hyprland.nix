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
    { lib, ... }:
    let
      lua = lib.generators.mkLuaInline;
      mod = key: lua ''mainMod .. " + ${key}"'';
      exec = command: "hl.dsp.exec_cmd(${builtins.toJSON command})";
      bind = keys: dispatcher: {
        _args = [
          keys
          (lua dispatcher)
        ];
      };
      bindExec = keys: command: bind keys (exec command);
      bindMouse = keys: dispatcher: {
        _args = [
          keys
          (lua dispatcher)
          { mouse = true; }
        ];
      };
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        configType = "lua";
        systemd.enable = false;
        importantPrefixes = [
          "config"
          "gesture"
          "window_rule"
          "bind"
        ];

        settings = {
          mainMod._var = "SUPER";

          config = {
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
              col = {
                active_border = lua "colors.accent";
                inactive_border = lua "colors.surface0";
              };
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

            dwindle.preserve_split = true;

            master = {
              orientation = "left";
              mfact = 0.50;
            };

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              vrr = 2;
            };
          };

          gesture = {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          };

          window_rule = [
            # Workspace assignments
            {
              match.class = "^(brave-browser)$";
              workspace = "1";
            }
            {
              match.class = "^(Alacritty)$";
              workspace = "2";
            }
            {
              match.class = "^(org\\.telegram\\.desktop)$";
              workspace = "3";
            }
            {
              match.class = "^(steam)$";
              workspace = "4";
            }
            {
              match.class = "^(steam_app_\\d+)$";
              workspace = "5";
            }
            {
              match.class = "^(gnome-pomodoro)$";
              workspace = "special";
            }

            # Center all floating windows
            {
              match.float = true;
              center = true;
            }

            # Floating dialogs (sized)
            {
              match.class = "^(xdg-desktop-portal-gtk)$";
              float = true;
              size = [
                "(monitor_w*0.4)"
                "(monitor_h*0.4)"
              ];
            }
            {
              match.class = "^(org.pulseaudio.pavucontrol)$";
              float = true;
              size = [
                "(monitor_w*0.5)"
                "(monitor_h*0.5)"
              ];
            }
            {
              match.initial_title = "^(_crx_.*)$";
              float = true;
              size = [
                "(monitor_w*0.15)"
                "(monitor_h*0.4)"
              ];
            }

            # Floating dialogs (auto-size)
            {
              match.class = "^(gnome-calculator|org\\.gnome\\.Calculator)$";
              float = true;
            }

            # Screen sharing
            {
              match.title = "^(Select what to share)$";
              float = true;
            }
            {
              match.title = "^(.*is sharing (your screen|a window)\\.)$";
              float = true;
              pin = true;
              border_size = 0;
              move = [
                "((monitor_w-window_w)/2)"
                "(monitor_h-window_h)"
              ];
            }
          ];

          bind = [
            # Layout controls
            (bind (mod "Return") ''hl.dsp.layout("swapwithmaster")'')
            (bind (mod "R") ''hl.dsp.layout("orientationcycle")'')

            # Window management
            (bind (mod "Q") "hl.dsp.window.close()")
            (bindExec "CTRL + ALT + Q" "uwsm stop")
            (bind (mod "F") ''hl.dsp.window.float({ action = "toggle" })'')
            (bind (mod "M") ''hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'')
            (bind (mod "SHIFT + M") ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')

            # Special workspace
            (bind (mod "P") ''hl.dsp.workspace.toggle_special("special")'')
            (bind (mod "SHIFT + P") ''hl.dsp.window.move({ workspace = "special", follow = false })'')

            # Move focus with mainMod + vim keys
            (bind (mod "l") ''hl.dsp.focus({ direction = "r" })'')
            (bind (mod "h") ''hl.dsp.focus({ direction = "l" })'')
            (bind (mod "k") ''hl.dsp.focus({ direction = "u" })'')
            (bind (mod "j") ''hl.dsp.focus({ direction = "d" })'')

            # Move windows with mainMod + CTRL + vim keys
            (bind (mod "CTRL + h") ''hl.dsp.window.move({ direction = "l" })'')
            (bind (mod "CTRL + j") ''hl.dsp.window.move({ direction = "d" })'')
            (bind (mod "CTRL + k") ''hl.dsp.window.move({ direction = "u" })'')
            (bind (mod "CTRL + l") ''hl.dsp.window.move({ direction = "r" })'')

            # Resize windows with mainMod + SHIFT + arrow keys
            (bind (mod "SHIFT + left") "hl.dsp.window.resize({ x = -50, y = 0, relative = true })")
            (bind (mod "SHIFT + right") "hl.dsp.window.resize({ x = 50, y = 0, relative = true })")
            (bind (mod "SHIFT + up") "hl.dsp.window.resize({ x = 0, y = -50, relative = true })")
            (bind (mod "SHIFT + down") "hl.dsp.window.resize({ x = 0, y = 50, relative = true })")

            # Center focused window
            (bind "CTRL + ALT + C" "hl.dsp.window.center()")

            # Switch workspaces with mainMod + [1-5]
            (bind (mod "1") "hl.dsp.focus({ workspace = 1 })")
            (bind (mod "2") "hl.dsp.focus({ workspace = 2 })")
            (bind (mod "3") "hl.dsp.focus({ workspace = 3 })")
            (bind (mod "4") "hl.dsp.focus({ workspace = 4 })")
            (bind (mod "5") "hl.dsp.focus({ workspace = 5 })")

            # Move active window to a workspace with mainMod + SHIFT + [1-5]
            (bind (mod "SHIFT + 1") "hl.dsp.window.move({ workspace = 1 })")
            (bind (mod "SHIFT + 2") "hl.dsp.window.move({ workspace = 2 })")
            (bind (mod "SHIFT + 3") "hl.dsp.window.move({ workspace = 3 })")
            (bind (mod "SHIFT + 4") "hl.dsp.window.move({ workspace = 4 })")
            (bind (mod "SHIFT + 5") "hl.dsp.window.move({ workspace = 5 })")

            # Scroll through existing workspaces with mainMod + scroll
            (bind (mod "mouse_down") ''hl.dsp.focus({ workspace = "e+1" })'')
            (bind (mod "mouse_up") ''hl.dsp.focus({ workspace = "e-1" })'')

            # Launch applications
            (bindExec (mod "SHIFT + Return") "alacritty")
            (bindExec (mod "SHIFT + B") "brave")
            (bindExec (mod "SHIFT + F") "nautilus")
            (bindExec (mod "SHIFT + T") "Telegram")
            (bindExec "CTRL + ALT + P" "gnome-pomodoro --start-stop")

            # Application launcher
            (bindExec "CTRL + Space" "noctalia-shell ipc call launcher toggle")

            # Clipboard history
            (bindExec "ALT + SHIFT + V" "noctalia-shell ipc call launcher clipboard")

            # Pick color from screen and copy to clipboard
            (bindExec (mod "SHIFT + C") "hyprpicker -a")

            # OCR
            (bindExec "ALT + SHIFT + 2" "ocr")

            # Screenshot area
            (bindExec (mod "SHIFT + S") "wayblast area | swappy -f -")

            # Screenshot entire screen
            (bindExec (mod "CTRL + S") "wayblast fullscreen | swappy -f -")

            # Screen recording
            (bindExec (mod "SHIFT + R") "toggle-screen-recording")

            # Lock screen
            (bindExec "CTRL + ALT + L" "noctalia-shell ipc call lockScreen lock")

            # Toggle control center panel
            (bindExec (mod "C") "noctalia-shell ipc call controlCenter toggle")

            # Open notifications history
            (bindExec (mod "N") "noctalia-shell ipc call notifications toggleHistory")

            # Clear all notifications
            (bindExec (mod "SHIFT + Backspace") "noctalia-shell ipc call notifications clear")

            # Adjust brightness
            (bindExec "XF86MonBrightnessUp" "noctalia-shell ipc call brightness increase")
            (bindExec "XF86MonBrightnessDown" "noctalia-shell ipc call brightness decrease")

            # Adjust volume
            (bindExec "XF86AudioRaiseVolume" "noctalia-shell ipc call volume increase")
            (bindExec "XF86AudioLowerVolume" "noctalia-shell ipc call volume decrease")
            (bindExec "XF86AudioMute" "noctalia-shell ipc call volume muteOutput")

            # Adjust mic sensitivity
            (bindExec "SHIFT + XF86AudioRaiseVolume" "noctalia-shell ipc call volume increaseInput")
            (bindExec "SHIFT + XF86AudioLowerVolume" "noctalia-shell ipc call volume decreaseInput")
            (bindExec "SHIFT + XF86AudioMute" "noctalia-shell ipc call volume muteInput")

            # Move/resize windows with mainMod + LMB/RMB and dragging
            (bindMouse (mod "mouse:272") "hl.dsp.window.drag()")
            (bindMouse (mod "mouse:273") "hl.dsp.window.resize()")
          ];
        };
      };

      xdg = {
        desktopEntries = {
          quit-all-applications = {
            name = "Quit All Applications";
            exec = ''hyprctl eval "for _, w in ipairs(hl.get_windows()) do hl.dispatch(hl.dsp.window.close({ window = w })) end"'';
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
