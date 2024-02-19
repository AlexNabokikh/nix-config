{...}: {
  # Manage kanshi services via Home-manager
  systemd.user.services.kanshi = {
    serviceConfig = {
      StartLimitBurst = 5;
      StartLimitIntervalSec = 30;
    };
  };
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "2880x1800@60Hz";
          }
        ];
      };
      docked = {
        outputs = [
          {
            criteria = "DP-1";
            mode = "2560x1440@59.95";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}
