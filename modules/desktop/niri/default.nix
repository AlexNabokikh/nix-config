{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.modules.nixos.niri = {
    imports = [ nixos.compositorCommon ];

    home-manager.sharedModules = [
      homeManager.compositorCommon
      homeManager.niri
    ];

    programs.niri.enable = true;
  };

  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.xwayland-satellite ];

      xdg.desktopEntries.quit-all-applications = {
        name = "Quit All Applications";
        exec = ''${pkgs.bash}/bin/bash -lc "niri msg -j windows | jq -r '.[].id' | xargs -r -I {} niri msg action close-window --id {}"'';
        icon = "system-log-out";
      };

      xdg.configFile."niri/config.kdl".source = ./config.kdl;
    };
}
