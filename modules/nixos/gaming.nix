{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ homeManager.gaming ];

      programs.steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      boot.kernelParams = [
        "split_lock_detect=off"
        "vsyscall=emulate"
      ];

      services.pipewire.extraConfig.pipewire."10-gaming" = {
        "context.properties" = {
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
        };
      };
    };

  flake.modules.homeManager.gaming =
    { lib, ... }:
    {
      xdg.configFile."niri/config.kdl".text = lib.mkAfter ''
        // Gaming workspaces
        workspace "steam"
        workspace "games"

        window-rule {
            match app-id=r#"^steam$"#
            default-column-width { proportion 1.0; }
            open-on-workspace "steam"
        }

        window-rule {
            match app-id=r#"^steam_app_\d+$"#
            open-on-workspace "games"
        }

        window-rule {
            match app-id=r#"^steam_app_\d+$"#
            exclude title="^$"
            open-fullscreen true
            variable-refresh-rate true
        }
      '';
    };
}
