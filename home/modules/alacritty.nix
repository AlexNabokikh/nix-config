{pkgs, ...}: {
  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "zsh";
      shell.args = [
        "-l"
        "-c"
        "tmux attach || tmux "
      ];

      env = {
        TERM = "xterm-256color";
      };

      window = {
        decorations = "none";
        dynamic_title = false;
        dynamic_padding = true;
        dimensions = {
          columns = 170;
          lines = 45;
        };
        padding = {
          x = 5;
          y = 1;
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size = 12;
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
      };

      import = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/3c808cbb4f9c87be43ba5241bc57373c793d2f17/catppuccin-macchiato.yml";
          hash = "sha256-+m8FyPStdh1A1xMVBOkHpfcaFPcyVL99tIxHuDZ2zXI=";
        })
      ];

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };

      live_config_reload = true;

      key_bindings = [
        {
          key = "X";
          mods = "Control";
          action = "ToggleViMode";
        }
        {
          key = "J";
          mods = "Control";
          action = "ScrollLineDown";
        }
        {
          key = "K";
          mods = "Control";
          action = "ScrollLineUp";
        }
      ];
    };
  };
}
