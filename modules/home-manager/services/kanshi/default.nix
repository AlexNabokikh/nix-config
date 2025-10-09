{ ... }:
{
  # Manage kanshi service via Home-manager
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "*";
            position = "0,0";
            scale = 1.0;
            status = "enable";
          }
          {
            criteria = "eDP-1";
            scale = 2.0;
            status = "disable";
          }
        ];
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
        ];
      }
    ];
  };
}
