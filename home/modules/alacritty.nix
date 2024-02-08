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
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/832787d6cc0796c9f0c2b03926f4a83ce4d4519b/catppuccin-macchiato.toml";
          hash = "sha256-m0Y8OBD9Pgjw9ARwjeD8a+JIQRDboVVCywQS8/ZBAcc=";
        })
      ];

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };

      live_config_reload = true;
    };
  };
}
