{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin;
      uiFont = config.profile.appearance.fonts.ui.family;
      monospaceFont = config.profile.appearance.fonts.monospace.family;

      paletteFile = "${
        inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.palette
      }/palette.json";
      palette = builtins.fromJSON (builtins.readFile paletteFile);
      flavorPalette = palette.${catppuccin.flavor}.colors;
      color = name: flavorPalette.${name}.hex;
      accentColor = color catppuccin.accent;

      jsonFormat = pkgs.formats.json { };

      noctaliaColors = {
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

      noctaliaPlugins = {
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

      privacyIndicatorSettings = {
        hideInactive = true;
        enableToast = false;
        iconSpacing = 4;
        removeMargins = true;
        activeColor = "error";
        inactiveColor = "none";
      };

      noctaliaSettings = {
        appLauncher = {
          autoPasteClipboard = false;
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWrapText = true;
          customLaunchPrefix = "";
          customLaunchPrefixEnabled = false;
          density = "default";
          enableClipPreview = true;
          enableClipboardChips = false;
          enableClipboardHistory = true;
          enableClipboardSmartIcons = false;
          enableSessionSearch = true;
          enableSettingsSearch = false;
          enableWindowsSearch = false;
          iconMode = "tabler";
          ignoreMouseInput = false;
          overviewLayer = false;
          pinnedApps = [ ];
          position = "center";
          screenshotAnnotationTool = "";
          showCategories = false;
          showIconBackground = false;
          sortByMostUsed = false;
          terminalCommand = "alacritty -e";
          viewMode = "list";
        };

        audio = {
          mprisBlacklist = [ ];
          preferredPlayer = "";
          spectrumFrameRate = 30;
          spectrumMirrored = true;
          visualizerType = "linear";
          volumeFeedback = false;
          volumeFeedbackSoundFile = "";
          volumeOverdrive = false;
          volumeStep = 5;
        };

        bar = {
          autoHideDelay = 500;
          autoShowDelay = 150;
          backgroundOpacity = 0.93;
          barType = "simple";
          capsuleColorKey = "none";
          capsuleOpacity = 1;
          contentPadding = 2;
          density = "default";
          displayMode = "always_visible";
          enableExclusionZoneInset = true;
          fontScale = 1;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = true;
          marginHorizontal = 4;
          marginVertical = 4;
          middleClickAction = "none";
          middleClickCommand = "";
          middleClickFollowMouse = false;
          monitors = [ ];
          mouseWheelAction = "none";
          mouseWheelWrap = true;
          outerCorners = false;
          position = "top";
          reverseScroll = false;
          rightClickAction = "controlCenter";
          rightClickCommand = "";
          rightClickFollowMouse = true;
          screenOverrides = [ ];
          showCapsule = false;
          showOnWorkspaceSwitch = true;
          showOutline = false;
          useSeparateOpacity = false;
          widgetSpacing = 6;
          widgets = {
            center = [
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
            ];
            left = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.6;
                showApplications = false;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 1;
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }
              {
                displayMode = "forceOpen";
                iconColor = "none";
                id = "KeyboardLayout";
                showIcon = true;
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "";
                textColor = "none";
              }
              {
                deviceNativePath = "";
                displayMode = "graphic-clean";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = false;
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
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

        brightness = {
          backlightDeviceMappings = [ ];
          brightnessStep = 5;
          enableDdcSupport = false;
          enforceMinimum = true;
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

        colorSchemes = {
          darkMode = true;
          generationMethod = "tonal-spot";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          monitorForColors = "";
          predefinedScheme = "Noctalia (default)";
          schedulingMode = "off";
          syncGsettings = false;
          useWallpaperColors = false;
        };

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
          diskPath = "/";
          position = "close_to_bar_button";
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

        desktopWidgets = {
          enabled = false;
          gridSnap = false;
          gridSnapScale = false;
          monitorWidgets = [ ];
          overviewEnabled = true;
        };

        dock = {
          animationSpeed = 1;
          backgroundOpacity = 1;
          colorizeIcons = false;
          deadOpacity = 0.6;
          displayMode = "auto_hide";
          dockType = "floating";
          enabled = false;
          floatingRatio = 1;
          groupApps = false;
          groupClickAction = "cycle";
          groupContextMenuMode = "extended";
          groupIndicatorStyle = "dots";
          inactiveIndicators = false;
          indicatorColor = "primary";
          indicatorOpacity = 0.6;
          indicatorThickness = 3;
          launcherIcon = "";
          launcherIconColor = "none";
          launcherPosition = "end";
          launcherUseDistroLogo = false;
          monitors = [ ];
          onlySameOutput = true;
          pinnedApps = [ ];
          pinnedStatic = false;
          position = "bottom";
          showDockIndicator = false;
          showLauncherIcon = false;
          sitOnFrame = false;
          size = 1;
        };

        general = {
          allowPanelsOnScreenWithoutBar = true;
          allowPasswordWithFprintd = false;
          animationDisabled = true;
          animationSpeed = 1;
          autoStartAuth = false;
          avatarImage = config.profile.avatar;
          boxRadiusRatio = 1;
          clockFormat = "hh\\nmm";
          clockStyle = "custom";
          compactLockScreen = true;
          dimmerOpacity = 0.2;
          enableBlurBehind = false;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = false;
          enableShadows = false;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
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
          language = "";
          lockOnSuspend = true;
          lockScreenAnimations = false;
          lockScreenBlur = 0;
          lockScreenCountdownDuration = 10000;
          lockScreenMonitors = [ ];
          lockScreenTint = 0;
          passwordChars = false;
          radiusRatio = 1;
          reverseScroll = false;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showChangelogOnStartup = false;
          showHibernateOnLockScreen = false;
          showScreenCorners = false;
          showSessionButtonsOnLockScreen = true;
          smoothScrollEnabled = true;
          telemetryEnabled = false;
        };

        hooks = {
          colorGeneration = "";
          darkModeChange = "";
          enabled = false;
          performanceModeDisabled = "";
          performanceModeEnabled = "";
          screenLock = "";
          screenUnlock = "";
          session = "";
          startup = "";
          wallpaperChange = "";
        };

        idle = {
          customCommands = "[]";
          enabled = false;
          fadeDuration = 5;
          lockCommand = "";
          lockTimeout = 660;
          resumeLockCommand = "";
          resumeScreenOffCommand = "";
          resumeSuspendCommand = "";
          screenOffCommand = "";
          screenOffTimeout = 600;
          suspendCommand = "";
          suspendTimeout = 1800;
        };

        location = {
          analogClockInCalendar = false;
          autoLocate = false;
          firstDayOfWeek = -1;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;
          name = "Warsaw";
          showCalendarEvents = false;
          showCalendarWeather = false;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = false;
          weatherShowEffects = false;
          weatherTaliaMascotAlways = false;
        };

        network = {
          bluetoothAutoConnect = true;
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          bluetoothRssiPollIntervalMs = 60000;
          bluetoothRssiPollingEnabled = false;
          disableDiscoverability = false;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
        };

        nightLight = {
          autoSchedule = false;
          dayTemp = "6500";
          enabled = true;
          forced = false;
          manualSunrise = "06:00";
          manualSunset = "20:00";
          nightTemp = "4000";
        };

        noctaliaPerformance = {
          disableDesktopWidgets = true;
          disableWallpaper = true;
        };

        sessionMenu = {
          countdownDuration = 10000;
          enableCountdown = false;
          largeButtonsLayout = "single-row";
          largeButtonsStyle = true;
          position = "center";
          powerOptions = [
            {
              action = "lock";
              enabled = true;
              keybind = "1";
            }
            {
              action = "suspend";
              enabled = true;
              keybind = "2";
            }
            {
              action = "hibernate";
              enabled = true;
              keybind = "3";
            }
            {
              action = "reboot";
              enabled = true;
              keybind = "4";
            }
            {
              action = "logout";
              enabled = true;
              keybind = "5";
            }
            {
              action = "shutdown";
              enabled = true;
              keybind = "6";
            }
          ];
          showHeader = true;
          showKeybinds = true;
        };

        settingsVersion = 59;

        notifications = {
          backgroundOpacity = 1;
          clearDismissed = true;
          criticalUrgencyDuration = 15;
          density = "compact";
          enableBatteryToast = true;
          enableKeyboardLayoutToast = false;
          enableMarkdown = false;
          enableMediaToast = false;
          enabled = true;
          location = "top_right";
          lowUrgencyDuration = 3;
          monitors = [ ];
          normalUrgencyDuration = 8;
          overlayLayer = true;
          respectExpireTimeout = false;
          saveToHistory = {
            critical = true;
            low = true;
            normal = true;
          };
          sounds = {
            criticalSoundFile = "";
            enabled = false;
            excludedApps = "discord,firefox,chrome,chromium,edge";
            lowSoundFile = "";
            normalSoundFile = "";
            separateSounds = false;
            volume = 0.5;
          };
        };

        osd = {
          autoHideMs = 2000;
          backgroundOpacity = 1;
          enabled = true;
          enabledTypes = [
            0
            1
            2
          ];
          location = "top_right";
          monitors = [ ];
          overlayLayer = true;
        };

        plugins = {
          autoUpdate = false;
          notifyUpdates = true;
        };

        systemMonitor = {
          batteryCriticalThreshold = 5;
          batteryWarningThreshold = 20;
          cpuCriticalThreshold = 90;
          cpuWarningThreshold = 80;
          criticalColor = "";
          diskAvailCriticalThreshold = 10;
          diskAvailWarningThreshold = 20;
          diskCriticalThreshold = 90;
          diskWarningThreshold = 80;
          enableDgpuMonitoring = false;
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
          gpuCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          memCriticalThreshold = 90;
          memWarningThreshold = 80;
          swapCriticalThreshold = 90;
          swapWarningThreshold = 80;
          tempCriticalThreshold = 90;
          tempWarningThreshold = 80;
          useCustomColors = false;
          warningColor = "";
        };

        templates = {
          activeTemplates = [ ];
          enableUserTheming = false;
        };

        ui = {
          boxBorderEnabled = false;
          fontDefault = uiFont;
          fontDefaultScale = 1;
          fontFixed = monospaceFont;
          fontFixedScale = 1;
          panelBackgroundOpacity = 0.93;
          panelsAttachedToBar = true;
          scrollbarAlwaysVisible = true;
          settingsPanelMode = "centered";
          settingsPanelSideBarCardStyle = false;
          tooltipsEnabled = true;
          translucentWidgets = false;
        };

        wallpaper = {
          automationEnabled = false;
          directory = "";
          enableMultiMonitorDirectories = false;
          enabled = true;
          favorites = [ ];
          fillColor = "#000000";
          fillMode = "crop";
          hideWallpaperFilenames = false;
          linkLightAndDarkWallpapers = true;
          monitorDirectories = [ ];
          overviewBlur = 0.4;
          overviewEnabled = true;
          overviewTint = 0.6;
          panelPosition = "follow_bar";
          randomIntervalSec = 300;
          setWallpaperOnAllMonitors = true;
          showHiddenFiles = false;
          skipStartupTransition = true;
          solidColor = "#1a1a2e";
          sortOrder = "name";
          transitionDuration = 0;
          transitionEdgeSmoothness = 0.05;
          transitionType = [
            "fade"
            "disc"
            "stripes"
            "wipe"
            "pixelate"
            "honeycomb"
          ];
          useOriginalImages = false;
          useSolidColor = false;
          useWallhaven = false;
          viewMode = "single";
          wallhavenApiKey = "";
          wallhavenCategories = "111";
          wallhavenOrder = "desc";
          wallhavenPurity = "100";
          wallhavenQuery = "";
          wallhavenRatios = "";
          wallhavenResolutionHeight = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenSorting = "relevance";
          wallpaperChangeMode = "random";
        };
      };

      settingsFile = jsonFormat.generate "noctalia-settings.json" noctaliaSettings;
      colorsFile = jsonFormat.generate "noctalia-colors.json" noctaliaColors;
      pluginsFile = jsonFormat.generate "noctalia-plugins.json" noctaliaPlugins;
      privacyIndicatorSettingsFile = jsonFormat.generate "noctalia-privacy-indicator-settings.json" privacyIndicatorSettings;
    in
    {
      home = {
        packages = [ pkgs.noctalia-shell ];

        file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
          defaultWallpaper = config.profile.wallpaper;
        };
      };

      xdg.configFile = {
        "noctalia/settings.json".source = settingsFile;
        "noctalia/colors.json".source = colorsFile;
        "noctalia/plugins.json".source = pluginsFile;
        "noctalia/plugins/privacy-indicator/settings.json".source = privacyIndicatorSettingsFile;
      };

      systemd.user.services.noctalia-shell = {
        Unit = {
          Description = "Noctalia Shell - Wayland desktop shell";
          Documentation = "https://docs.noctalia.dev";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
          X-Restart-Triggers = [
            "${settingsFile}"
            "${colorsFile}"
            "${pluginsFile}"
            "${privacyIndicatorSettingsFile}"
          ];
        };

        Service = {
          ExecStart = lib.getExe pkgs.noctalia-shell;
          Restart = "on-failure";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
