{ ... }:
{
  flake.modules.homeManager.desktopHyprland =
    { pkgs, ... }:
    {
      # Expose a launcher action that closes all compositor-managed windows.
      xdg.desktopEntries = {
        quit-all-applications = {
          name = "Quit All Applications";
          exec = ''${pkgs.bash}/bin/bash -lc "hyprctl -j clients | jq -r '.[].address' | xargs -r -I {} hyprctl dispatch closewindow address:{}"'';
          icon = "system-log-out";
        };
      };

      # Source hyprland config from the home-manager store
      xdg.configFile = {
        "hypr/hyprland.conf" = {
          source = ./hyprland.conf;
        };

        "hypr/xdph.conf".text = ''
          screencopy {
            allow_token_by_default = true
            max_fps = 60
          }
        '';
      };
    };
}
