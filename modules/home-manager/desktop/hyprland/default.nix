{ ... }:
{
  flake.modules.homeManager.desktopHyprland =
    {
      pkgs,
      ...
    }:
    {
      xdg.desktopEntries.quit-all-applications = {
        name = "Quit All Applications";
        exec = ''${pkgs.bash}/bin/bash -lc "hyprctl -j clients | jq -r '.[].address' | xargs -r -I {} hyprctl dispatch closewindow address:{}"'';
        icon = "system-log-out";
      };

      xdg.desktopEntries.uuctl = {
        name = "uuctl";
        noDisplay = true;
      };

      xdg.configFile = {
        "hypr/hyprland.conf".source = ./hyprland.conf;

        "hypr/xdph.conf".text = ''
          screencopy {
            allow_token_by_default = true
            max_fps = 60
          }
        '';
      };
    };
}
