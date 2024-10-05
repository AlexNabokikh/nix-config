{
  pkgs,
  lib,
  ...
}: let
  ulauncher_config = ./../../files/configs/ulauncher;
  manageShortcutsScript = pkgs.writeScriptBin "manage-ulauncher-shortcuts" ''
    #!/usr/bin/env bash
    set -euo pipefail

    configDir="$HOME/.config/ulauncher"
    shortcutsFile="$configDir/shortcuts.json"

    # Ensure the configuration directory exists
    mkdir -p "$configDir"

    # JSON content to ensure is in `shortcuts.json`
    cat > "$shortcutsFile" << 'EOF'
    {
      "6524dac6-7723-4a88-b920-65b1f96ee946": {
          "id": "6524dac6-7723-4a88-b920-65b1f96ee946",
          "name": "search",
          "keyword": "br",
          "cmd": "https://search.brave.com/search?q=%s",
          "icon": "~/.config/ulauncher/brave.png",
          "is_default_search": true,
          "run_without_argument": false,
          "added": 1684850439.0202124
      },
      "0eb1c1b7-8e36-4a13-abd4-0b6bb1f7bdb9": {
          "id": "0eb1c1b7-8e36-4a13-abd4-0b6bb1f7bdb9",
          "name": "Quit All Applications",
          "keyword": "quit",
          "cmd": "#!/usr/bin/env bash\nif [ \"$XDG_SESSION_TYPE\" = \"wayland\" ]; then\n\tHYPRCMDS=$(hyprctl -j clients | jq -j '.[] | \"dispatch closewindow address:\\(.address); \"')\n\thyprctl --batch \"$HYPRCMDS\" 2>&1\nelse\n\tWIN_IDs=$(wmctrl -l | grep -vwE \"Desktop$|xfce4-panel$\" | cut -f1 -d' ')\n\tfor i in $WIN_IDs; do wmctrl -ic \"$i\"; done\n\twhile test \"$WIN_IDs\"; do\n\t\tsleep 0.1\n\t\tWIN_IDs=$(wmctrl -l | grep -vwE \"Desktop$|xfce4-panel$\" | cut -f1 -d' ')\n\tdone\nfi",
          "icon": "~/.config/ulauncher/quit.png",
          "is_default_search": false,
          "run_without_argument": true,
          "added": 1687024658.867567
      },
      "b7d20d83-ca3d-4c5d-8705-1b567fa8dcee": {
          "id": "b7d20d83-ca3d-4c5d-8705-1b567fa8dcee",
          "name": "Work Tools",
          "keyword": "work",
          "cmd": "#!/usr/bin/env bash\n\n# Check if Brave is already running\nif ! pgrep \"brave\" >/dev/null; then\n\techo \"Launching Brave...\"\n\tbrave &\nelse\n\techo \"Brave is already running.\"\nfi\n\n# Check if Alacritty is already running\nif ! pgrep -x \"alacritty\" >/dev/null; then\n\techo \"Launching Alacritty...\"\n\talacritty &\nelse\n\techo \"Alacritty is already running.\"\nfi\n\n# Check if Telegram is already running\nif ! pgrep -x \"telegram-desktop\" >/dev/null; then\n\techo \"Launching Telegram...\"\n\ttelegram-desktop\nelse\n\techo \"Telegram is already running.\"\nfi",
          "icon": "~/.config/ulauncher/tools.png",
          "is_default_search": false,
          "run_without_argument": true,
          "added": 1687025817.105349
      }
    }
    EOF

    # Adjust file paths within the JSON
    sed -i "s|\\\$HOME|$HOME|g" "$shortcutsFile"
  '';
in {
  # Ulauncher package
  home.packages = with pkgs; [
    ulauncher
  ];

  # Ulauncher service configuration
  systemd.user.services.ulauncher = {
    Unit = {
      Description = "ulauncher application launcher service";
      Documentation = "https://ulauncher.io";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -lc '${pkgs.ulauncher}/bin/ulauncher --hide-window --no-window-shadow'";
      Restart = "always";
    };

    Install.WantedBy = ["graphical-session.target"];
  };

  # Source ulauncher configuration from this repository
  xdg.configFile = {
    "ulauncher" = {
      recursive = true;
      source = "${ulauncher_config}";
    };
  };

  # A bit nasty, but shortcuts file has to be writeble by the ulauncher
  home.activation.manageShortcuts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${manageShortcutsScript}/bin/manage-ulauncher-shortcuts
  '';
}
