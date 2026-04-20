{
  flake.modules.homeManager.desktopNiri =
    { pkgs, ... }:
    {
      xdg.desktopEntries.quit-all-applications = {
        name = "Quit All Applications";
        exec = ''${pkgs.bash}/bin/bash -lc "niri msg -j windows | jq -r '.[].id' | xargs -r -I {} niri msg action close-window --id {}"'';
        icon = "system-log-out";
      };

      xdg.configFile."niri/config.kdl".source = ./config.kdl;
    };
}
