{
  pkgs,
  userConfig,
  ...
}: {
  # Ensure flameshot package installed
  home.packages = with pkgs; [
    flameshot
  ];

  xdg.configFile = {
    "flameshot/flameshot.ini".text = ''
      [General]
      disabledTrayIcon=true
      contrastOpacity=96
      drawColor=#ff2800
      drawFontSize=4
      saveAsFileExtension=.png
      savePath = "${
        if pkgs.stdenv.isDarwin
        then "/Users"
        else "/home"
      }/${userConfig.name}/Pictures";
      savePathFixed=true
      showDesktopNotification=false
      showHelp=false
      showMagnifier=true
      showStartupLaunchMessage=false
      squareMagnifier=true
      startupLaunch=true
      uiColor=#8aadf4
    '';
  };
}
