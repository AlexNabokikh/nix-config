{pkgs, ...}: {
  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };

      terminal = {
        shell.program = "zsh";
        shell.args = [
          "-l"
          "-c"
          "tmux attach || tmux "
        ];
      };

      env = {
        TERM = "xterm-256color";
      };

      window = {
        decorations =
          if pkgs.stdenv.isDarwin
          then "buttonless"
          else "none";
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

      keyboard.bindings =
        if pkgs.stdenv.isDarwin
        then [
          {
            key = "Slash";
            mods = "Control";
            chars = ''\u001f'';
          }
        ]
        else [];

      font = {
        size =
          if pkgs.stdenv.isDarwin
          then 15
          else 12;
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

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };
    };
  };

  # Enable catppuccin theming for alacritty.
  catppuccin.alacritty.enable = true;
}
