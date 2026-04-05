{ ... }:
{
  # NixOS-level Hyprland configuration
  flake.modules.nixos.desktopHyprland =
    { pkgs, ... }:
    {
      # Enable Hyprland
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      # FIXME: https://github.com/NixOS/nixpkgs/issues/484328
      services.displayManager.defaultSession = "hyprland-uwsm";

      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/start-hyprland";
          };
        };
      };

      # Hyprland specific packages
      environment.systemPackages = with pkgs; [
        grimblast
        hyprpicker
      ];
    };

  # Home-manager-level Hyprland configuration
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
