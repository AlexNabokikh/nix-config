{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.nixos.gnome =
    { lib, pkgs, ... }:
    {
      home-manager.sharedModules = [ homeManager.gnome ];

      services = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
        dleyna.enable = false;
        geoclue2.enable = false;
        gnome = {
          core-apps.enable = false;
          evolution-data-server.enable = lib.mkForce false;
          gcr-ssh-agent.enable = false;
          gnome-browser-connector.enable = false;
          gnome-initial-setup.enable = false;
          gnome-online-accounts.enable = false;
          gnome-remote-desktop.enable = false;
          gnome-user-share.enable = false;
          rygel.enable = false;
        };
      };

      environment.gnome.excludePackages = [ pkgs.gnome-tour ];
    };

  flake.modules.homeManager.gnome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.hm.gvariant)
        mkTuple
        mkUint32
        ;

      inputSources = [
        (mkTuple [
          "xkb"
          "pl"
        ])
        (mkTuple [
          "xkb"
          "ru"
        ])
      ];

      customKeybindingPath = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings";

      customKeybindings = {
        custom0 = {
          binding = "<Shift><Super>Return";
          command = "alacritty";
          name = "Alacritty";
        };

        custom1 = {
          binding = "<Shift><Super>b";
          command = "brave";
          name = "Brave";
        };

        custom2 = {
          binding = "<Shift><Super>f";
          command = "nautilus";
          name = "Files";
        };

        custom3 = {
          binding = "<Shift><Super>t";
          command = "Telegram";
          name = "Telegram";
        };

        custom4 = {
          binding = "<Ctrl><Alt>s";
          command = "gradia --screenshot=full";
          name = "Gradia Full Screenshot";
        };

        custom5 = {
          binding = "<Super><Shift>s";
          command = "gradia --screenshot";
          name = "Gradia Interactive Screenshot";
        };
      };

      quitAllApplications = pkgs.writeShellApplication {
        name = "quit-all-applications";
        runtimeInputs = with pkgs; [
          findutils
          jq
          systemd
        ];
        text = ''
          busctl --user --json=short call \
            org.gnome.Shell \
            /org/gnome/Shell/Extensions/Windows \
            org.gnome.Shell.Extensions.Windows \
            List \
            | jq -r '.data[0] | fromjson | .[].id' \
            | xargs -r -n1 busctl --user call \
                org.gnome.Shell \
                /org/gnome/Shell/Extensions/Windows \
                org.gnome.Shell.Extensions.Windows \
                Close u
        '';
      };
    in
    {
      imports = [
        homeManager.cursor
        homeManager.desktopApps
        homeManager.gtk
        homeManager.qt
        homeManager.xdgUserDirs
      ];

      home = {
        packages = [ pkgs.gradia ];
        sessionVariables.XCURSOR_SIZE = null;
      };

      programs.gnome-shell = {
        enable = true;
        extensions = [
          { package = pkgs.gnomeExtensions.auto-move-windows; }
          { package = pkgs.gnomeExtensions.blur-my-shell; }
          { package = pkgs.gnomeExtensions.clipboard-history; }
          { package = pkgs.gnomeExtensions.just-perfection; }
          { package = pkgs.gnomeExtensions.pop-shell; }
          { package = pkgs.gnomeExtensions.rounded-window-corners-reborn; }
          { package = pkgs.gnomeExtensions.window-calls; }
        ];
      };

      dconf.settings = {
        "be/alexandervanhee/gradia" = {
          draw-mode = "ARROW";
          exit-method = "none";
          overwrite-screenshot = true;
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file://${config.profile.wallpaper.light}";
          picture-uri-dark = "file://${config.profile.wallpaper.dark}";
          primary-color = "#000000000000";
        };

        "org/gnome/desktop/input-sources" = {
          sources = inputSources;
        };

        "org/gnome/desktop/interface" = {
          enable-animations = false;
          enable-hot-corners = false;
          show-battery-percentage = true;
        };

        "org/gnome/desktop/peripherals/keyboard" = {
          delay = mkUint32 250;
          repeat-interval = mkUint32 20;
        };

        "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
        "org/gnome/desktop/sound".event-sounds = false;
        "org/gnome/gnome-session".logout-prompt = false;

        "org/gnome/desktop/wm/keybindings" = {
          close = [ "<Super>q" ];
          minimize = [ ];
          move-to-center = [ "<Control><Alt>c" ];

          maximize = [ ];
          unmaximize = [ ];
          move-to-monitor-left = [ ];
          move-to-monitor-right = [ ];
          move-to-monitor-up = [ ];
          move-to-monitor-down = [ ];

          move-to-workspace-1 = [ "<Super><Shift>1" ];
          move-to-workspace-2 = [ "<Super><Shift>2" ];
          move-to-workspace-3 = [ "<Super><Shift>3" ];
          move-to-workspace-4 = [ "<Super><Shift>4" ];
          move-to-workspace-5 = [ "<Super><Shift>5" ];

          switch-applications = [ "<Alt>Tab" ];
          switch-applications-backward = [ "<Shift><Alt>Tab" ];

          switch-to-workspace-1 = [ "<Super>1" ];
          switch-to-workspace-2 = [ "<Super>2" ];
          switch-to-workspace-3 = [ "<Super>3" ];
          switch-to-workspace-4 = [ "<Super>4" ];
          switch-to-workspace-5 = [ "<Super>5" ];

          toggle-fullscreen = [ "<Super><Shift>m" ];
          toggle-maximized = [ "<Super>m" ];
        };

        "org/gnome/desktop/wm/preferences" = {
          focus-mode = "sloppy";
        };

        "org/gnome/mutter" = {
          auto-maximize = false;
          edge-tiling = false;
          focus-change-on-pointer-rest = false;
        };

        "org/gnome/mutter/keybindings" = {
          toggle-tiled-left = [ ];
          toggle-tiled-right = [ ];
        };

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-temperature = mkUint32 4000;
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = map (name: "/${customKeybindingPath}/${name}/") (
            builtins.attrNames customKeybindings
          );

          logout = [
            "<Control><Alt>Delete"
            "<Alt><Ctrl>q"
          ];
          screensaver = [ "<Alt><Ctrl>l" ];
        };

        "org/gnome/shell/extensions/auto-move-windows".application-list = [
          "brave-browser.desktop:1"
          "Alacritty.desktop:2"
          "org.telegram.desktop.desktop:3"
          "steam.desktop:4"
        ];

        "org/gnome/shell/extensions/clipboard-history" = {
          display-mode = 3;
          next-entry = [ "<Shift><Alt>j" ];
          prev-entry = [ "<Shift><Alt>k" ];
          toggle-menu = [ "<Shift><Alt>v" ];
        };

        "org/gnome/shell/extensions/just-perfection" = {
          animation = 0;
          dash = false;
          notification-banner-position = 2;
          panel-button-padding-size = 5;
          panel-indicator-padding-size = 9;
          support-notifier-type = 0;
        };

        "org/gnome/shell/extensions/pop-shell" = {
          gap-inner = mkUint32 1;
          gap-outer = mkUint32 1;
          mouse-cursor-focus-location = mkUint32 4;
          tile-by-default = true;
        };

        "org/gnome/shell".disable-extension-version-validation = true;

        "org/gnome/shell".favorite-apps = [ ];

        "org/gnome/shell/keybindings" = {
          focus-active-notification = [ ];
          screenshot = [ ];
          show-screen-recording-ui = [ "<Shift><Super>r" ];
          show-screenshot-ui = [ ];

          toggle-quick-settings = [ "<Super>c" ];
          toggle-message-tray = [ "<Super>n" ];

          switch-to-application-1 = [ ];
          switch-to-application-2 = [ ];
          switch-to-application-3 = [ ];
          switch-to-application-4 = [ ];
          switch-to-application-5 = [ ];
          switch-to-application-6 = [ ];
          switch-to-application-7 = [ ];
          switch-to-application-8 = [ ];
          switch-to-application-9 = [ ];
        };

        "system/locale".region = config.profile.locale.extra.LC_TIME;
      }
      // lib.mapAttrs' (
        name: value: lib.nameValuePair "${customKeybindingPath}/${name}" value
      ) customKeybindings;

      xdg = {
        desktopEntries.quit-all-applications = {
          name = "Quit All Applications";
          exec = lib.getExe quitAllApplications;
          icon = "system-log-out";
        };

        configFile."pop-shell/config.json".text = builtins.toJSON {
          float = [
            { class = "be.alexandervanhee.gradia"; }
            { class = "crx_.*"; }
            { class = "org.gnome.Calculator"; }
            { class = "wl-clipboard"; }
            {
              class = "^(steam|steamwebhelper)$";
              title = ".*(login|sign in|loading|starting|updating|splash|logout|log out|sign out).*";
            }
            { title = "crx_.*"; }
            { title = "^(.*is sharing (your screen|a window)\\.)$"; }
          ];
        };
      };
    };
}
