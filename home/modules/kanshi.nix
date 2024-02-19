{pkgs, ...}: {
  # Install kanshi via home-manager module
  home.packages = with pkgs; [
    kanshi
  ];

  # Manage kanshi services via Home-manager
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    profiles = {
      docked = {
        outputs = [
          {
            criteria = "DP-1";
            status = "enable";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
        ];
      };
    };
  };
}
