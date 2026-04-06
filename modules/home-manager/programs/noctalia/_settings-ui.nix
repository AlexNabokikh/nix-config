{
  uiFont,
  monospaceFont,
}:
{
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

  plugins.autoUpdate = false;

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
}
