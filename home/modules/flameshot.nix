{userConfig, ...}: {
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        checkForUpdates = "false";
        contrastOpacity = 188;
        disabledTrayIcon = "true";
        drawColor = "#ff2800";
        drawFontSize = "4";
        savePath = "/home/${userConfig.name}/Downloads/temp";
        showDesktopNotification = "false";
        showHelp = "false";
        showMagnifier = "true";
        showStartupLaunchMessage = "false";
        squareMagnifier = "true";
        startupLaunch = "true";
        uiColor = "#B7BDF8";
      };
    };
  };

  # Set env vars so flameshot works under wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
