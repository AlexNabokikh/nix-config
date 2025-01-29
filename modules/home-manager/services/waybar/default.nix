{...}: {
  # Install and configure waybar via home-manager module
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        ipc = true;
        margin-top = 3;
        margin-left = 4;
        margin-right = 4;

        modules-left = [
          "hyprland/workspaces"
          "cpu"
          "temperature"
          "memory"
          "backlight"
        ];

        modules-center = [
          "clock"
          "custom/notification"
        ];

        modules-right = [
          "custom/recorder"
          "hyprland/language"
          "tray"
          "bluetooth"
          "pulseaudio"
          "pulseaudio#microphone"
          "battery"
        ];

        backlight = {
          interval = 2;
          align = 0;
          rotate = 0;
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃝" "󰃠"];
          icon-size = 10;
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
          smooth-scrolling-threshold = 1;
        };

        battery = {
          interval = 60;
          align = 0;
          rotate = 0;
          full-at = 100;
          design-capacity = false;
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "<big>{icon}</big>  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-full = "{icon} Full";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-time = "{H}h {M}min";
          tooltip = true;
          tooltip-format = "{timeTo} {power}w";
        };

        bluetooth = {
          format = "";
          format-connected = " {num_connections}";
          tooltip-format = " {device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "Name: {device_alias}\nBattery: {device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        clock = {
          format = "{:%b %d %H:%M}";
          format-alt = " {:%H:%M   %Y, %d %B, %A}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = "󰍛 {usage}%";
          interval = 1;
        };

        "hyprland/language" = {
          format = "{short}";
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
          on-click = "activate";
          show-special = false;
          sort-by-number = true;
        };

        memory = {
          interval = 10;
          format = "󰾆 {used:0.1f}G";
          format-alt = "󰾆 {percentage}%";
          format-alt-click = "click";
          tooltip = true;
          tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
          on-click-right = "foot --title btop sh -c 'btop'";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
              " "
            ];
          };
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          scroll-step = 5;
          on-click-right = "pamixer -t";
          smooth-scrolling-threshold = 1;
          ignored-sinks = ["Easy Effects Sink"];
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "pavucontrol";
          on-click-right = "pamixer --default-source -t";
          on-scroll-up = "pamixer --default-source -i 5";
          on-scroll-down = "pamixer --default-source -d 5";
        };

        temperature = {
          interval = 10;
          tooltip = false;
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          critical-threshold = 82;
          format-critical = "{icon} {temperatureC}°C";
          format = "󰈸 {temperatureC}°C";
        };

        tray = {
          spacing = 20;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/recorder" = {
          format = "";
          tooltip = false;
          return-type = "json";
          exec = "echo '{\"class\": \"recording\"}'";
          exec-if = "pgrep wf-recorder";
          interval = 1;
          on-click = "screen-recorder";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        min-height: 0;
        font-size: 100%;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        padding: 0px;
        margin-top: 1px;
        margin-bottom: 1px;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0);
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      tooltip {
        background: #1e1e2e;
        border-radius: 8px;
      }

      tooltip label {
        color: #cad3f5;
        margin-right: 5px;
        margin-left: 5px;
      }

      .modules-right,
      .modules-center,
      .modules-left {
        background-color: rgba(0, 0, 0, 0.6);
        border: 0px solid #b4befe;
        border-radius: 8px;
      }

      #workspaces button {
        padding: 2px;
        color: #6e6a86;
        margin-right: 5px;
      }

      #workspaces button.active {
        color: #dfdfdf;
        border-radius: 3px 3px 3px 3px;
      }

      #workspaces button.focused {
        color: #d8dee9;
      }

      #workspaces button.urgent {
        color: #ed8796;
        border-radius: 8px;
      }

      #workspaces button:hover {
        color: #dfdfdf;
        border-radius: 3px;
      }

      #backlight,
      #battery,
      #bluetooth,
      #clock,
      #cpu,
      #custom-notification,
      #custom-recorder,
      #language,
      #memory,
      #tray,
      #pulseaudio,
      #temperature,
      #workspaces {
        color: #dfdfdf;
        padding: 0px 10px;
        border-radius: 8px;
      }

      #temperature.critical {
        background-color: #ff0000;
      }

      @keyframes blink {
        to {
          color: #000000;
        }
      }

      #taskbar button.active {
        background-color: #7f849c;
      }

      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #custom-recorder {
        color: #ff2800;
      }
    '';
  };
}
