{ inputs, ... }:
{
  flake.modules.homeManager.programsNoctalia =
    {
      config,
      pkgs,
      ...
    }:
    let
      catppuccin = config.profile.appearance.catppuccin;
      uiFont = config.profile.appearance.fonts.ui.family;
      monospaceFont = config.profile.appearance.fonts.monospace.family;

      paletteFile = "${
        inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.palette
      }/palette.json";
      palette = builtins.fromJSON (builtins.readFile paletteFile);
      flavorPalette = palette.${catppuccin.flavor}.colors;
      color = name: flavorPalette.${name}.hex;
      accentColor = color catppuccin.accent;
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
        defaultWallpaper = config.profile.wallpaper;
      };

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;

        colors = {
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
        };

        plugins = {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = "https://github.com/noctalia-dev/noctalia-plugins";
            }
          ];
          states = {
            privacy-indicator = {
              enabled = true;
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
            };
          };
          version = 1;
        };

        pluginSettings = {
          privacy-indicator = {
            hideInactive = true;
            enableToast = false;
            iconSpacing = 4;
            removeMargins = true;
            activeColor = "error";
            inactiveColor = "none";
          };
        };

        settings = {
          appLauncher = {
            enableClipboardHistory = true;
            enableSettingsSearch = false;
            enableWindowsSearch = false;
            showCategories = false;
            sortByMostUsed = false;
          };

          bar = {
            contentPadding = 0;
            hideOnOverview = true;
            outerCorners = false;
            showCapsule = false;
            widgets = {
              center = [
                { id = "Clock"; }
              ];
              left = [
                {
                  id = "Workspace";
                  hideUnoccupied = true;
                }
              ];
              right = [
                { id = "Tray"; }
                {
                  id = "KeyboardLayout";
                  displayMode = "forceOpen";
                }
                { id = "Network"; }
                {
                  id = "Volume";
                  middleClickCommand = "";
                }
                {
                  id = "Battery";
                  deviceNativePath = "";
                }
                { id = "NotificationHistory"; }
                {
                  defaultSettings = {
                    activeColor = "primary";
                    hideInactive = true;
                    inactiveColor = "none";
                    removeMargins = false;
                  };
                  id = "plugin:privacy-indicator";
                }
              ];
            };
          };

          calendar.cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
          ];

          controlCenter = {
            cards = [
              {
                enabled = true;
                id = "profile-card";
              }
              {
                enabled = true;
                id = "shortcuts-card";
              }
              {
                enabled = false;
                id = "audio-card";
              }
              {
                enabled = true;
                id = "brightness-card";
              }
              {
                enabled = false;
                id = "weather-card";
              }
              {
                enabled = false;
                id = "media-sysmon-card";
              }
            ];
            shortcuts = {
              left = [
                { id = "Network"; }
                { id = "Bluetooth"; }
                { id = "Notifications"; }
              ];
              right = [
                { id = "PowerProfile"; }
                { id = "NoctaliaPerformance"; }
                { id = "AirplaneMode"; }
              ];
            };
          };

          dock.enabled = false;

          general = {
            animationDisabled = true;
            avatarImage = config.profile.avatar;
            compactLockScreen = true;
            enableShadows = false;
            showChangelogOnStartup = false;
            keybinds = {
              keyDown = [ "Ctrl+J" ];
              keyEnter = [
                "Return"
                "Enter"
              ];
              keyEscape = [ "Esc" ];
              keyLeft = [ "Ctrl+H" ];
              keyRemove = [ "Del" ];
              keyRight = [ "Ctrl+L" ];
              keyUp = [ "Ctrl+K" ];
            };
          };

          location = {
            showCalendarEvents = false;
            showCalendarWeather = false;
            showWeekNumberInCalendar = true;
            weatherEnabled = false;
            weatherShowEffects = false;
          };

          network = {
            wifiEnabled = false;
          };

          nightLight = {
            autoSchedule = false;
            enabled = true;
            manualSunrise = "07:00";
            manualSunset = "20:00";
          };

          notifications = {
            density = "compact";
            enableKeyboardLayoutToast = false;
          };

          sessionMenu = {
            enableCountdown = false;
          };

          ui = {
            fontDefault = uiFont;
            fontFixed = monospaceFont;
            settingsPanelMode = "centered";
          };

          wallpaper = {
            skipStartupTransition = true;
            transitionDuration = 0;
          };
        };
      };
    };
}
