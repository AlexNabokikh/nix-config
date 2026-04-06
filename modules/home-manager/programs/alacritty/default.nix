{ ... }:
{
  flake.modules.homeManager.programsAlacritty =
    {
      config,
      pkgs,
      ...
    }:
    {
      # Install alacritty via home-manager module
      programs.alacritty = {
        enable = true;
        settings = {
          general = {
            live_config_reload = true;
          };

          terminal = {
            shell.program = "${pkgs.zsh}/bin/zsh";
            shell.args = [
              "-l"
              "-c"
              "tmux attach || tmux"
            ];
          };

          window = {
            decorations = if pkgs.stdenv.hostPlatform.isDarwin then "buttonless" else "full";
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
            if pkgs.stdenv.hostPlatform.isDarwin then
              [
                {
                  key = "Slash";
                  mods = "Control";
                  chars = ''\u001f'';
                }
              ]
            else
              [ ];

          font = {
            size =
              if pkgs.stdenv.hostPlatform.isDarwin then
                config.profile.appearance.fonts.terminal.size.darwin
              else
                config.profile.appearance.fonts.terminal.size.linux;
            normal = {
              family = config.profile.appearance.fonts.terminal.family;
              style = "Regular";
            };
            bold = {
              family = config.profile.appearance.fonts.terminal.family;
              style = "Bold";
            };
            italic = {
              family = config.profile.appearance.fonts.terminal.family;
              style = "Italic";
            };
            bold_italic = {
              family = config.profile.appearance.fonts.terminal.family;
              style = "Bold Italic";
            };
          };

          selection = {
            semantic_escape_chars = '',│`|:"' ()[]{}<>'';
            save_to_clipboard = true;
          };
        };
      };
    };
}
