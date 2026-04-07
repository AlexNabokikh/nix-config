{
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
    useApp2Unit = false;
    viewMode = "list";
  };

  audio = {
    mprisBlacklist = [ ];
    preferredPlayer = "";
    spectrumFrameRate = 30;
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
    contentPadding = 0;
    density = "default";
    displayMode = "always_visible";
    enableExclusionZoneInset = true;
    floating = false;
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
    launcherIconColor = "none";
    launcherPosition = "end";
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
}
