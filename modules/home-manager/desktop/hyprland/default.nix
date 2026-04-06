{ ... }:
{
  flake.modules.homeManager.desktopHyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.user.sessionVariables = {
        XCURSOR_THEME = lib.strings.toLower config.home.pointerCursor.name;
        XCURSOR_SIZE = toString config.home.pointerCursor.size;
      };

      xdg.desktopEntries.quit-all-applications = {
        name = "Quit All Applications";
        exec = ''${pkgs.bash}/bin/bash -lc "hyprctl -j clients | jq -r '.[].address' | xargs -r -I {} hyprctl dispatch closewindow address:{}"'';
        icon = "system-log-out";
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
