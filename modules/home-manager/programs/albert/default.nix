{
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    # Albert package
    home.packages = [ pkgs.albert ];

    # Source albert configuration from the home-manager store
    xdg.configFile."albert/config".text = ''
      [General]
      frontend=widgetsboxmodel-ng
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

      [debug]
      enabled=false

      [path]
      enabled=false

      [system]
      command_lock=loginctl lock-session
      command_logout="[[ \"$DESKTOP_SESSION\" == hyprland* ]] && { hyprctl -j clients 2>/dev/null | jq -j '.[] | \"dispatch closewindow address:\\(.address); \"' | xargs -r hyprctl --batch 2>/dev/null; } || [ \"$DESKTOP_SESSION\" = \"plasma\" ] && kdotool search '.*' windowclose %@ || true"
      command_poweroff=systemctl poweroff -i
      command_reboot=systemctl reboot -i
      enabled=true
      logout_enabled=true
      title_logout=Quit All Applications
      title_poweroff=Shutdown
      trigger=sys

      [widgetsboxmodel-ng]
      alwaysOnTop=true
      clearOnHide=true
      debug=false
      displayScrollbar=false
      followCursor=true
      hideOnFocusLoss=true
      historySearch=true
      itemCount=10
      quitOnClose=false
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
