{
  flake.modules.darwin.aerospace = {
    services.aerospace = {
      enable = true;
      settings = {
        config-version = 2;

        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        on-focus-changed = [ "move-mouse window-lazy-center" ];
        automatically-unhide-macos-hidden-apps = true;

        gaps = {
          inner = {
            horizontal = 6;
            vertical = 6;
          };
          outer = {
            left = 6;
            bottom = 6;
            top = 6;
            right = 6;
          };
        };

        mode = {
          main.binding = {
            alt-shift-enter = "exec-and-forget open -na alacritty";
            alt-shift-b = "exec-and-forget open -a \"Brave Browser\"";
            alt-shift-t = "exec-and-forget open -a \"Telegram\"";
            alt-shift-f = "exec-and-forget open -a Finder";

            alt-q = "close";
            alt-m = "fullscreen";
            alt-f = "layout floating tiling";

            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            alt-ctrl-h = "move left";
            alt-ctrl-j = "move down";
            alt-ctrl-k = "move up";
            alt-ctrl-l = "move right";

            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";

            alt-shift-1 = "move-node-to-workspace --focus-follows-window 1";
            alt-shift-2 = "move-node-to-workspace --focus-follows-window 2";
            alt-shift-3 = "move-node-to-workspace --focus-follows-window 3";
            alt-shift-4 = "move-node-to-workspace --focus-follows-window 4";
            alt-shift-5 = "move-node-to-workspace --focus-follows-window 5";
            alt-shift-6 = "move-node-to-workspace --focus-follows-window 6";
            alt-shift-7 = "move-node-to-workspace --focus-follows-window 7";
            alt-shift-8 = "move-node-to-workspace --focus-follows-window 8";
            alt-shift-9 = "move-node-to-workspace --focus-follows-window 9";

            alt-tab = "workspace-back-and-forth";
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            alt-p = "mode passthrough";
            alt-shift-semicolon = "mode service";
          };

          service.binding = {
            esc = [
              "reload-config"
              "mode main"
            ];
            r = [
              "flatten-workspace-tree"
              "mode main"
            ];
            f = [
              "layout floating tiling"
              "mode main"
            ];
            backspace = [
              "close-all-windows-but-current"
              "mode main"
            ];
            alt-shift-h = [
              "join-with left"
              "mode main"
            ];
            alt-shift-j = [
              "join-with down"
              "mode main"
            ];
            alt-shift-k = [
              "join-with up"
              "mode main"
            ];
            alt-shift-l = [
              "join-with right"
              "mode main"
            ];
          };

          passthrough.binding = {
            alt-p = "mode main";
            esc = "mode main";
          };
        };

        on-window-detected = [
          {
            "if".app-id = "com.brave.Browser";
            run = "move-node-to-workspace 1";
          }
          {
            "if".app-id = "org.alacritty";
            run = "move-node-to-workspace 2";
          }
          {
            "if".app-id = "com.tdesktop.Telegram";
            run = "move-node-to-workspace 3";
          }
          {
            "if".app-id = "us.zoom.xos";
            run = "move-node-to-workspace 5";
          }
        ];
      };
    };
  };
}
