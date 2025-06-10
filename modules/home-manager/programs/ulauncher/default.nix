{
  pkgs,
  lib,
  ...
}: let
  manageShortcutsScript = pkgs.writeScriptBin "manage-ulauncher-shortcuts" ''
    #!/usr/bin/env bash
    set -euo pipefail

    configDir="$HOME/.config/ulauncher"
    shortcutsFile="$configDir/shortcuts.json"

    # Ensure the configuration directory exists
    mkdir -p "$configDir"

    # JSON content to ensure is in `shortcuts.json`
    cat >"$shortcutsFile" <<'EOF'
    {
      "0155d149-516b-4f38-bdab-f51d245818e3": {
        "id": "0155d149-516b-4f38-bdab-f51d245818e3",
        "name": "Search",
        "keyword": "br",
        "cmd": "https://search.brave.com/search?q=%s",
        "icon": "~/.config/ulauncher/icons/brave.png",
        "is_default_search": true,
        "run_without_argument": false,
        "added": 1747897791.8054328
      },
      "11e80e5b-3841-403c-ae08-64e53372e7df": {
        "id": "11e80e5b-3841-403c-ae08-64e53372e7df",
        "name": "Quit All Applications",
        "keyword": "quit",
        "cmd": "#!/usr/bin/env bash\n\ncase \"$DESKTOP_SESSION\" in\nhyprland)\n\thyprctl -j clients 2>/dev/null |\n\t\tjq -j '.[] | \"dispatch closewindow address:\\(.address); \"' |\n\t\txargs -r hyprctl --batch 2>/dev/null\n\t;;\n\nplasma)\n\tkdotool search '.*' windowclose %@\n\t;;\n\n*)\n\texit 0\n\t;;\nesac",
        "icon": "~/.config/ulauncher/icons/quit.png",
        "is_default_search": false,
        "run_without_argument": true,
        "added": 1747897834.2170281
      },
      "b72345b1-312c-4a39-89fc-0265437c2ccf": {
        "id": "b72345b1-312c-4a39-89fc-0265437c2ccf",
        "name": "Work Tools",
        "keyword": "work",
        "cmd": "#!/usr/bin/env bash\n\n# Check if Brave is already running\nif ! pgrep \"brave\" >/dev/null; then\n\techo \"Launching Brave...\"\n\tbrave &\nelse\n\techo \"Brave is already running.\"\nfi\n\n# Check if Alacritty is already running\nif ! pgrep -x \"alacritty\" >/dev/null; then\n\techo \"Launching Alacritty...\"\n\talacritty &\nelse\n\techo \"Alacritty is already running.\"\nfi\n\n# Check if Telegram is already running\nif ! pgrep -x \"telegram-desktop\" >/dev/null; then\n\techo \"Launching Telegram...\"\n\ttelegram-desktop\nelse\n\techo \"Telegram is already running.\"\nfi",
        "icon": "~/.config/ulauncher/icons/tools.png",
        "is_default_search": false,
        "run_without_argument": true,
        "added": 1747897863.1040845
      },
      "56b485f3-9561-49af-9fe4-b4144efa9fb2": {
        "id": "56b485f3-9561-49af-9fe4-b4144efa9fb2",
        "name": "Lock\u2005Screen",
        "keyword": "lock",
        "cmd": "#!/usr/bin/env bash\n\nloginctl lock-session",
        "icon": "~/.config/ulauncher/icons/icon.svg",
        "is_default_search": false,
        "run_without_argument": true,
        "added": 1747898201.1167789
      },
      "8407589e-0e44-41cf-8a86-32d9cc3b45d5": {
        "id": "8407589e-0e44-41cf-8a86-32d9cc3b45d5",
        "name": "Suspend / Sleep",
        "keyword": "suspend",
        "cmd": "#!/usr/bin/env bash\n\nsystemctl suspend -i",
        "icon": "~/.config/ulauncher/icons/icon.svg",
        "is_default_search": false,
        "run_without_argument": true,
        "added": 1747898274.058171
      },
      "eda21a94-aa60-4db8-98cc-ff37687af457": {
        "id": "eda21a94-aa60-4db8-98cc-ff37687af457",
        "name": "Shut\u2005Down\u2005/\u2005Power\u2005Off",
        "keyword": "shutdown",
        "cmd": "#!/usr/bin/env bash\n\nsystemctl poweroff -i",
        "icon": "~/.config/ulauncher/icons/icon.svg",
        "is_default_search": false,
        "run_without_argument": true,
        "added": 1747898438.8860931
      },
      "dac53ff3-db88-451b-89b1-89e81cfdd165": {
        "id": "dac53ff3-db88-451b-89b1-89e81cfdd165",
        "name": "Reboot\u2005/\u2005Restart",
        "keyword": "reboot",
        "cmd": "#!/usr/bin/env bash\n\nsystemctl reboot -i",
        "icon": "~/.config/ulauncher/icons/icon.svg",
        "is_default_search": false,
        "run_without_argument": true,
        "added": 1747898972.3437614
      }
    }
    EOF
  '';
in {
  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    # Ulauncher package
    home.packages = with pkgs; [
      ulauncher
    ];

    # Source ulauncher configuration from this repository
    xdg.configFile = {
      "ulauncher" = {
        recursive = true;
        source = ./config;
      };
    };

    # A bit nasty, but shortcuts file has to be writeble by the ulauncher
    home.activation.manageShortcuts = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${manageShortcutsScript}/bin/manage-ulauncher-shortcuts
    '';
  };
}
