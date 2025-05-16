{
  pkgs,
  userConfig,
  ...
}: {
  # Ensure flameshot package installed
  home.packages = [
    (pkgs.writeShellScriptBin "flameshot" ''
      export XDG_SESSION_TYPE= QT_QPA_PLATFORM=wayland
      nohup ${pkgs.flameshot}/bin/flameshot >& /dev/null &
      ${pkgs.flameshot}/bin/flameshot "$@"
    '')
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
