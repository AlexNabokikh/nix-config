{
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    # Albert package
    home.packages = [ pkgs.albert ];

    # Source albert configuration from the home-manager store
    xdg.configFile."albert/config".text = ''
      [General]
      showTray=false
      telemetry=false

      [applications]
      enabled=true
      global_handler_enabled=true

      [chromium]
      enabled=true
      fuzzy=false
      global_handler_enabled=false
      trigger=bm

      [system]
      command_lock=loginctl lock-session
      command_logout=$HOME/.local/bin/quit-all-applications
      command_poweroff=systemctl poweroff -i
      command_reboot=systemctl reboot -i
      enabled=true
      logout_enabled=true
      title_logout=Quit All Applications
      title_poweroff=Shutdown
      trigger=sys

      [widgetsboxmodel]
      alwaysOnTop=true
      clearOnHide=true
      displayScrollbar=false
      followCursor=false
      hideOnFocusLoss=true
      historySearch=true
      itemCount=10
      showCentered=true
    '';

    systemd.user.services.albert = {
      Unit = {
        Description = "Albert Launcher";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.albert}/bin/albert";
        Restart = "always";
        RestartSec = "0s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
