{...}: {
  # Manage kanshi services via Home-manager
  services.kanshi = {
    enable = true;
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
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "ASUSTek COMPUTER INC VG27AQL1A L5LMQS180142 (DP-1)";
            mode = "2560x1440@170Hz";
            position = "0,0";
          }
        ];
      };
    };
  };
}
