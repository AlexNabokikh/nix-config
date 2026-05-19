{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.modules.nixos.hyprland =
    { config, ... }:
    {
      imports = [ nixos.compositorCommon ];

      home-manager.sharedModules = [
        homeManager.compositorCommon
        homeManager.hyprland
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      # Hyprland's quirk under uwsm. Without it, the cursor in XWayland applications is inconsistent.
      # https://wiki.hypr.land/Configuring/Environment-variables/
      environment.sessionVariables = {
        XCURSOR_SIZE = config.profile.appearance.cursorTheme.size;
        XCURSOR_THEME = config.profile.appearance.cursorTheme.name;
      };
    };

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        grimblast
        hyprpicker
      ];

      xdg = {
        desktopEntries = {
          quit-all-applications = {
            name = "Quit All Applications";
            exec = ''${pkgs.bash}/bin/bash -lc "hyprctl -j clients | jq -r '.[].address' | xargs -r -I {} hyprctl dispatch closewindow address:{}"'';
            icon = "system-log-out";
          };

          uuctl = {
            name = "uuctl";
            noDisplay = true;
          };
        };

        configFile = {
          "hypr/hyprland.conf".source = ./hyprland.conf;

          "hypr/xdph.conf".text = ''
            screencopy {
              allow_token_by_default = true
              max_fps = 60
            }
          '';
        };
      };
    };
}
