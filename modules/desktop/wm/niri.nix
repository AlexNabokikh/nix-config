{ config, ... }:
let
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.niri = {
    imports = [
      nixos.desktopApps
      nixos.noctaliaGreeter
    ];

    home-manager.sharedModules = [ homeManager.niri ];

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    programs.niri.enable = true;
  };

  flake.modules.homeManager.niri =
    {
      config,
      osConfig,
      pkgs,
      catppuccinColor,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin;
      color = catppuccinColor;
    in
    {
      imports = [
        homeManager.cursor
        homeManager.desktopApps
        homeManager.gtk
        homeManager.noctalia
        homeManager.qt
        homeManager.xdgUserDirs
      ];

      xdg.desktopEntries.quit-all-applications = {
        name = "Quit All Applications";
        exec = ''${pkgs.bash}/bin/bash -lc "niri msg -j windows | jq -r '.[].id' | xargs -r -I {} niri msg action close-window --id {}"'';
        icon = "system-log-out";
      };

      wayland.windowManager.niri = {
        enable = true;
        package = osConfig.programs.niri.package;
        checkConfig = true;
        systemd.enable = false;
        portalPackage = null;

        settings.cursor = {
          xcursor-theme = config.home.pointerCursor.name;
          xcursor-size = config.home.pointerCursor.size;
        };

        extraConfig = ''
          // Monitor settings
          output "DP-1" {
              variable-refresh-rate on-demand=true
          }

          // Input device settings
          input {
              keyboard {
                  xkb {
                      layout "pl,ru"
                  }
                  repeat-delay 250
                  repeat-rate 40
              }

              touchpad {
                  tap
                  natural-scroll
              }

              mouse {
                  accel-profile "flat"
                  accel-speed 0
              }

              trackpoint {
                  off
              }

              focus-follows-mouse max-scroll-amount="0%"
          }

          // General settings
          prefer-no-csd

          hotkey-overlay {
              skip-at-startup
          }

          gestures {
              hot-corners {
                  off
              }
          }

          // Layout settings
          layout {
              background-color "#000000"
              gaps 6
              center-focused-column "never"

              preset-column-widths {
                  proportion 0.5
                  proportion 0.66667
                  proportion 0.33333
              }

              default-column-width { proportion 0.5; }

              focus-ring {
                  width 1
                  active-color "${color catppuccin.accent}"
                  inactive-color "${color "surface0"}"
              }

              border {
                  off
              }

              shadow {
                  off
              }
          }

          // Animations settings
          animations {
              off
          }

          // Blur settings
          blur {
              off
          }

          // Workspaces
          workspace "main"
          workspace "terminal"
          workspace "messages"
          workspace "steam"
          workspace "games"

          // Layer rules
          layer-rule {
              match namespace="^noctalia-backdrop"
              place-within-backdrop true
          }

          layer-rule {
              match namespace="^noctalia-"
              background-effect {
                  blur false
              }
          }

          // Window rules (global)
          window-rule {
              clip-to-geometry true
              draw-border-with-background false
              geometry-corner-radius 8
              open-maximized-to-edges false
          }

          // Workspace assignments
          window-rule {
              match app-id=r#"^brave-browser$"#
              default-column-width { proportion 1.0; }
              open-on-workspace "main"
          }

          window-rule {
              match app-id=r#"^Alacritty$"#
              default-column-width { proportion 1.0; }
              open-on-workspace "terminal"
          }

          window-rule {
              match app-id=r#"^org\.telegram\.desktop$"#
              exclude title=r#"(Choose Files|Media viewer|Save (File|Video|Image))"#
              default-column-width { proportion 1.0; }
              open-on-workspace "messages"
          }

          window-rule {
              match app-id=r#"^steam$"#
              default-column-width { proportion 1.0; }
              open-on-workspace "steam"
          }

          window-rule {
              match app-id=r#"^steam_app_\d+$"#
              open-on-workspace "games"
          }

          // Floating dialogs
          window-rule {
              match app-id=r#"^org\.pulseaudio\.pavucontrol$"#
              open-floating true
          }

          window-rule {
              match app-id=r#"^brave-nngceckbapebfimnlniiiahkandclblb-.+$"#
              open-floating true
          }

          window-rule {
              match app-id=r#"^(gnome-calculator|org\.gnome\.Calculator)$"#
              open-floating true
          }

          window-rule {
              match app-id="^anki$" title="^Study Deck$"
              open-floating true
          }

          // Screen sharing
          window-rule {
              match title=r#"^.*is sharing (your screen|a window)\.$"#
              focus-ring {
                  off
              }
              border {
                  off
              }
              open-floating true
              default-floating-position x=0 y=0 relative-to="bottom"
          }

          // Games
          window-rule {
              match app-id=r#"^steam_app_\d+$"#
              exclude title="^$"
              open-fullscreen true
              variable-refresh-rate true
          }

          // Bindings
          binds {
              // Launch applications
              Mod+Shift+Return repeat=false hotkey-overlay-title="Open Terminal" { spawn "alacritty"; }
              Mod+Shift+B repeat=false hotkey-overlay-title="Open Brave" { spawn "brave"; }
              Mod+Shift+F repeat=false hotkey-overlay-title="Open Nautilus" { spawn "nautilus"; }
              Mod+Shift+T repeat=false hotkey-overlay-title="Open Telegram" { spawn "Telegram"; }

              // Application launcher
              Ctrl+Space repeat=false hotkey-overlay-title="Toggle Launcher" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }

              // Clipboard history
              Alt+Shift+V repeat=false hotkey-overlay-title="Clipboard History" { spawn "noctalia" "msg" "panel-toggle" "clipboard"; }

              // Pick color from screen and copy to clipboard
              Mod+Shift+C repeat=false hotkey-overlay-title="Color Picker" { spawn-sh "niri msg pick-color | grep '^Hex:' | cut -d' ' -f2 | wl-copy"; }

              // Screenshot area
              Mod+Shift+S repeat=false hotkey-overlay-title="Screenshot Area" { spawn "noctalia" "msg" "screenshot-region"; }

              // Screenshot entire screen
              Mod+Ctrl+S repeat=false hotkey-overlay-title="Screenshot Screen" { spawn "noctalia" "msg" "screenshot-fullscreen"; }

              // Screen recording
              Mod+Shift+R repeat=false hotkey-overlay-title="Toggle Screen Recording" { spawn "noctalia" "msg" "plugin" "noctalia/screen_recorder:service" "all" "toggle"; }

              // Lock screen
              Ctrl+Alt+L repeat=false hotkey-overlay-title="Lock Screen" { spawn "noctalia" "msg" "session" "lock"; }

              // Toggle control center panel
              Mod+C repeat=false hotkey-overlay-title="Toggle Control Center" { spawn "noctalia" "msg" "panel-toggle" "control-center"; }

              // Open notifications history
              Mod+N repeat=false hotkey-overlay-title="Toggle Notifications" { spawn "noctalia" "msg" "panel-toggle" "control-center" "notifications"; }

              // Clear all notifications
              Mod+Shift+Backspace repeat=false hotkey-overlay-title="Clear Notifications" { spawn "noctalia" "msg" "notification-clear-history"; }

              // Adjust brightness
              XF86MonBrightnessUp allow-when-locked=true { spawn "noctalia" "msg" "brightness-up"; }
              XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia" "msg" "brightness-down"; }

              // Adjust volume
              XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-up"; }
              XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia" "msg" "volume-down"; }
              XF86AudioMute repeat=false allow-when-locked=true { spawn "noctalia" "msg" "volume-mute"; }

              // Adjust mic sensitivity
              Shift+XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia" "msg" "mic-volume-up"; }
              Shift+XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia" "msg" "mic-volume-down"; }
              Shift+XF86AudioMute repeat=false allow-when-locked=true { spawn "noctalia" "msg" "mic-mute"; }

              // Window management
              Mod+Q repeat=false { close-window; }
              Mod+F repeat=false { toggle-window-floating; }
              Mod+M repeat=false { maximize-column; }
              Mod+Shift+M repeat=false { fullscreen-window; }
              Mod+O repeat=false { toggle-overview; }

              // Move focus with Mod + vim keys / arrows
              Mod+H     { focus-column-left; }
              Mod+J     { focus-window-down; }
              Mod+K     { focus-window-up; }
              Mod+L     { focus-column-right; }

              // Move windows with Mod + Ctrl + vim keys / arrows
              Mod+Ctrl+H     { move-column-left; }
              Mod+Ctrl+J     { move-window-down; }
              Mod+Ctrl+K     { move-window-up; }
              Mod+Ctrl+L     { move-column-right; }

              // Switch workspaces with Mod + [0-9]
              Mod+1 repeat=false { focus-workspace 1; }
              Mod+2 repeat=false { focus-workspace 2; }
              Mod+3 repeat=false { focus-workspace 3; }
              Mod+4 repeat=false { focus-workspace 4; }
              Mod+5 repeat=false { focus-workspace 5; }
              Mod+6 repeat=false { focus-workspace 6; }
              Mod+7 repeat=false { focus-workspace 7; }
              Mod+8 repeat=false { focus-workspace 8; }
              Mod+9 repeat=false { focus-workspace 9; }

              // Move active column to a workspace with Mod + Shift + [0-9]
              Mod+Shift+1 repeat=false { move-column-to-workspace 1; }
              Mod+Shift+2 repeat=false { move-column-to-workspace 2; }
              Mod+Shift+3 repeat=false { move-column-to-workspace 3; }
              Mod+Shift+4 repeat=false { move-column-to-workspace 4; }
              Mod+Shift+5 repeat=false { move-column-to-workspace 5; }
              Mod+Shift+6 repeat=false { move-column-to-workspace 6; }
              Mod+Shift+7 repeat=false { move-column-to-workspace 7; }
              Mod+Shift+8 repeat=false { move-column-to-workspace 8; }
              Mod+Shift+9 repeat=false { move-column-to-workspace 9; }

              // Column management
              Mod+BracketLeft  { consume-or-expel-window-left; }
              Mod+BracketRight { consume-or-expel-window-right; }
              Mod+Comma  { consume-window-into-column; }
              Mod+Period { expel-window-from-column; }

              // Resize windows
              Mod+R repeat=false { switch-preset-column-width; }

              // Switch keyboard layout
              Mod+Space repeat=false { switch-layout "next"; }

              // Misc
              Ctrl+Alt+Q repeat=false { quit; }
          }
        '';
      };
    };
}
