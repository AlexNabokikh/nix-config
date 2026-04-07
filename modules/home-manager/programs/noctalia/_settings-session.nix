{ avatar }:
{
  general = {
    allowPanelsOnScreenWithoutBar = true;
    allowPasswordWithFprintd = false;
    animationDisabled = true;
    animationSpeed = 1;
    autoStartAuth = false;
    avatarImage = avatar;
    boxRadiusRatio = 1;
    clockFormat = "hh\nmm";
    clockStyle = "custom";
    compactLockScreen = true;
    dimmerOpacity = 0.2;
    enableBlurBehind = true;
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
    airplaneModeEnabled = false;
    bluetoothAutoConnect = true;
    bluetoothDetailsViewMode = "grid";
    bluetoothHideUnnamedDevices = false;
    bluetoothRssiPollIntervalMs = 10000;
    bluetoothRssiPollingEnabled = false;
    disableDiscoverability = false;
    networkPanelView = "wifi";
    wifiDetailsViewMode = "grid";
    wifiEnabled = false;
  };

  nightLight = {
    autoSchedule = false;
    dayTemp = "6500";
    enabled = true;
    forced = false;
    manualSunrise = "07:00";
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
    showKeybinds = true;
  };

  settingsVersion = 57;
}
