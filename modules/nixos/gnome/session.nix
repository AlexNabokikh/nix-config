# GNOME user session: shell extensions, dconf, look and feel.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  wallpaperLight = ../../../assets/wallpapers/wallpaper-light.png;
  wallpaperDark = ../../../assets/wallpapers/wallpaper-dark.png;

  inherit (lib.hm.gvariant)
    mkArray
    mkDictionaryEntry
    mkTuple
    mkUint32
    mkVariant
    ;

  mkVariantDictionary =
    attrs:
    mkArray "{sv}" (
      lib.mapAttrsToList (
        name: value:
        mkDictionaryEntry [
          name
          (mkVariant value)
        ]
      ) attrs
    );

  customKeybindingPath = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings";

  customKeybindings = {
    alacritty = {
      binding = "<Shift><Super>Return";
      command = "alacritty";
      name = "Alacritty";
    };
    brave = {
      binding = "<Shift><Super>b";
      command = "brave";
      name = "Brave";
    };
    files = {
      binding = "<Shift><Super>f";
      command = "nautilus";
      name = "Files";
    };
    telegram = {
      binding = "<Shift><Super>t";
      command = "Telegram";
      name = "Telegram";
    };
    gradia-full = {
      binding = "<Ctrl><Alt>s";
      command = "gradia --screenshot=full";
      name = "Gradia Full Screenshot";
    };
    gradia-interactive = {
      binding = "<Super><Shift>s";
      command = "gradia --screenshot";
      name = "Gradia Interactive Screenshot";
    };
  };
in
{
  home = {
    pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    # GNOME/gsd-xsettings picks the cursor size itself (scaling-aware); don't pin it.
    sessionVariables.XCURSOR_SIZE = null;

    packages = [ pkgs.gradia ];
  };

  gtk = {
    enable = true;
    gtk2.enable = false;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Documents"
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/Pictures"
      "file://${config.home.homeDirectory}/Videos"
    ];
  };

  qt = {
    enable = true;
    platformTheme.name = "xdgdesktopportal";
  };

  programs.gnome-shell = {
    enable = true;
    extensions = map (package: { inherit package; }) (
      with pkgs.gnomeExtensions;
      [
        auto-move-windows
        blur-my-shell
        clipboard-history
        just-perfection
        pop-shell
        rounded-window-corners-reborn
      ]
    );
  };

  dconf.settings = lib.mkMerge [
    {
      "be/alexandervanhee/gradia" = {
        exit-method = "none";
        overwrite-screenshot = true;
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${wallpaperLight}";
        picture-uri-dark = "file://${wallpaperDark}";
      };

      "org/gnome/desktop/input-sources".sources = [
        (mkTuple [
          "xkb"
          "pl"
        ])
        (mkTuple [
          "xkb"
          "ru"
        ])
      ];

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-animations = false;
        enable-hot-corners = false;
        show-battery-percentage = true;
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = mkUint32 250;
        repeat-interval = mkUint32 20;
      };

      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/session".idle-delay = mkUint32 0;
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

        switch-applications = [ "<Alt>Tab" ];
        switch-applications-backward = [ "<Shift><Alt>Tab" ];

        toggle-fullscreen = [ "<Super><Shift>m" ];
        toggle-maximized = [ "<Super>m" ];

        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];

        move-to-workspace-1 = [ "<Super><Shift>1" ];
        move-to-workspace-2 = [ "<Super><Shift>2" ];
        move-to-workspace-3 = [ "<Super><Shift>3" ];
        move-to-workspace-4 = [ "<Super><Shift>4" ];
        move-to-workspace-5 = [ "<Super><Shift>5" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "";
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

      "org/gnome/nautilus/preferences".default-folder-viewer = "list-view";

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = false;
        night-light-temperature = mkUint32 4000;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = map (name: "/${customKeybindingPath}/${name}/") (
          builtins.attrNames customKeybindings
        );

        logout = [ "<Alt><Ctrl>q" ];
        screensaver = [ "<Alt><Ctrl>l" ];
      };

      "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";

      "org/gnome/shell/extensions/auto-move-windows".application-list = [
        "brave-browser.desktop:1"
        "Alacritty.desktop:2"
        "org.telegram.desktop.desktop:3"
        "steam.desktop:4"
      ];

      "org/gnome/shell/extensions/blur-my-shell/popup".static-blur = true;

      "org/gnome/shell/extensions/clipboard-history" = {
        cache-size = 20;
        display-mode = 3;
        history-size = 100;
        next-entry = [ "<Shift><Alt>j" ];
        prev-entry = [ "<Shift><Alt>k" ];
        toggle-menu = [ "<Shift><Alt>v" ];
      };

      "org/gnome/shell/extensions/just-perfection" = {
        animation = 0;
        dash = false;
        notification-banner-position = 2;
        support-notifier-type = 0;
      };

      "org/gnome/shell/extensions/pop-shell" = {
        gap-inner = mkUint32 1;
        gap-outer = mkUint32 1;
        mouse-cursor-focus-location = mkUint32 4;
        tile-by-default = true;
      };

      "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
        border-width = 1;
        settings-version = mkUint32 9;
        global-rounded-corner-settings = mkVariantDictionary {
          padding = mkVariantDictionary {
            left = mkUint32 1;
            right = mkUint32 1;
            top = mkUint32 1;
            bottom = mkUint32 1;
          };
          keepRoundedCorners = mkVariantDictionary {
            maximized = false;
            fullscreen = false;
          };
          borderRadius = mkUint32 15;
          smoothing = 0.0;
          borderColor = mkTuple [
            1.0
            1.0
            1.0
            0.07
          ];
          enabled = true;
        };
      };

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

      "org/gtk/gtk4/settings/file-chooser".show-hidden = true;

      # Regional formats; the locale is compiled in by i18n.extraLocales in ./default.nix.
      "system/locale".region = "en_IE.UTF-8";
    }
    (lib.mapAttrs' (
      name: value: lib.nameValuePair "${customKeybindingPath}/${name}" value
    ) customKeybindings)
  ];

  xdg = {
    terminal-exec = {
      enable = true;
      settings.default = [ "Alacritty.desktop" ];
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
}
