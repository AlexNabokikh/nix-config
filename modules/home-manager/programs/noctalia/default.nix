{
  config,
  inputs,
  pkgs,
  userConfig,
  ...
}:
let
  paletteFile = "${
    inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.palette
  }/palette.json";
  palette = builtins.fromJSON (builtins.readFile paletteFile);
  flavorPalette = palette.${config.catppuccin.flavor}.colors;
  color = name: flavorPalette.${name}.hex;
  accentColor = color config.catppuccin.accent;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = userConfig.wallpaper;
    };
  };

  programs.noctalia-shell = {
    enable = true;
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
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
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
        removeMargins = true;
      };
    };
    systemd.enable = true;
    settings = {
      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWrapText = true;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        density = "default";
        enableClipPreview = true;
        enableClipboardHistory = true;
        enableSessionSearch = false;
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
        sortByMostUsed = true;
        terminalCommand = "alacritty -e";
        useApp2Unit = false;
        viewMode = "list";
      };
      audio = {
        cavaFrameRate = 30;
        mprisBlacklist = [ ];
        preferredPlayer = "";
        visualizerType = "linear";
        volumeFeedback = false;
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
        density = "default";
        displayMode = "always_visible";
        floating = false;
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = true;
        marginHorizontal = 4;
        marginVertical = 4;
        monitors = [ ];
        outerCorners = false;
        position = "top";
        screenOverrides = [ ];
        showCapsule = false;
        showOutline = false;
        useSeparateOpacity = false;
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
            {
              hideWhenZero = false;
              hideWhenZeroUnread = false;
              iconColor = "none";
              id = "NotificationHistory";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
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
              groupedBorderOpacity = 1;
              hideUnoccupied = true;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              reverseScroll = false;
              showApplications = false;
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
              displayMode = "onhover";
              hideIfIdle = false;
              hideIfNotDetected = true;
              id = "Battery";
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
            }
            {
              defaultSettings = {
                audioCodec = "opus";
                audioSource = "default_output";
                colorRange = "limited";
                copyToClipboard = false;
                directory = "";
                filenamePattern = "recording_yyyyMMdd_HHmmss";
                frameRate = "60";
                hideInactive = true;
                quality = "very_high";
                showCursor = true;
                videoCodec = "h264";
                videoSource = "portal";
              };
              id = "plugin:screen-recorder";
            }
            {
              defaultSettings = {
                activeColor = "primary";
                hideInactive = false;
                inactiveColor = "none";
                removeMargins = false;
              };
              id = "plugin:privacy-indicator";
            }
          ];
        };
      };
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = false;
        enforceMinimum = true;
      };
      calendar = {
        cards = [
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
      };
      colorSchemes = {
        darkMode = true;
        generationMethod = "tonal-spot";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        monitorForColors = "";
        predefinedScheme = "Noctalia (default)";
        schedulingMode = "off";
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
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Notifications";
            }
          ];
          right = [
            {
              id = "PowerProfile";
            }
            {
              id = "NightLight";
            }
            {
              defaultSettings = {
                audioCodec = "opus";
                audioSource = "default_output";
                colorRange = "limited";
                copyToClipboard = false;
                directory = "";
                filenamePattern = "recording_yyyyMMdd_HHmmss";
                frameRate = "60";
                hideInactive = true;
                quality = "very_high";
                showCursor = true;
                videoCodec = "h264";
                videoSource = "portal";
              };
              id = "plugin:screen-recorder";
            }
          ];
        };
      };
      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [ ];
      };
      dock = {
        animationSpeed = 1;
        backgroundOpacity = 1;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        enabled = false;
        floatingRatio = 1;
        inactiveIndicators = false;
        monitors = [ ];
        onlySameOutput = true;
        pinnedApps = [ ];
        pinnedStatic = false;
        position = "bottom";
        size = 1;
      };
      general = {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = false;
        animationDisabled = true;
        animationSpeed = 1;
        autoStartAuth = false;
        avatarImage = userConfig.avatar;
        boxRadiusRatio = 1;
        clockFormat = "hh\\nmm";
        clockStyle = "custom";
        compactLockScreen = true;
        dimmerOpacity = 0.2;
        enableLockScreenCountdown = true;
        enableShadows = false;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        keybinds = {
          keyDown = [ "Ctrl+J" ];
          keyEnter = [ "Return" ];
          keyEscape = [ "Esc" ];
          keyLeft = [ "Ctrl+H" ];
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
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = false;
        showHibernateOnLockScreen = false;
        showScreenCorners = false;
        showSessionButtonsOnLockScreen = true;
        telemetryEnabled = false;
      };
      hooks = {
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
      location = {
        analogClockInCalendar = false;
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
      };
      network = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        wifiEnabled = false;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = true;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };
      notifications = {
        backgroundOpacity = 1;
        criticalUrgencyDuration = 15;
        density = "default";
        enableBatteryToast = true;
        enableKeyboardLayoutToast = false;
        enableMediaToast = false;
        enabled = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [ ];
        normalUrgencyDuration = 7;
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
      };
      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = false;
        largeButtonsLayout = "grid";
        largeButtonsStyle = false;
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
      };
      settingsVersion = 53;
      systemMonitor = {
        batteryCriticalThreshold = 5;
        batteryWarningThreshold = 20;
        cpuCriticalThreshold = 90;
        cpuPollingInterval = 5000;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskAvailCriticalThreshold = 10;
        diskAvailWarningThreshold = 20;
        diskCriticalThreshold = 90;
        diskPollingInterval = 10000;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuPollingInterval = 5000;
        gpuWarningThreshold = 80;
        loadAvgPollingInterval = 5000;
        memCriticalThreshold = 90;
        memPollingInterval = 5000;
        memWarningThreshold = 80;
        networkPollingInterval = 1000;
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
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
        fontDefault = "Roboto";
        fontDefaultScale = 1;
        fontFixed = "JetBrainsMono Nerd Font Mono";
        fontFixedScale = 1;
        networkPanelView = "wifi";
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        tooltipsEnabled = true;
        wifiDetailsViewMode = "grid";
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
        transitionType = "random";
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
  };
}
