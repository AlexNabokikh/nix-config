{
  flake.modules.homeManager.alacritty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      promptNewlineChars = builtins.fromJSON ''"\u001b\u000d"'';
    in
    {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal = {
            shell.program = "${pkgs.zsh}/bin/zsh";
            shell.args = [
              "-l"
              "-c"
              "tmux attach || tmux"
            ];
          };

          window = {
            decorations = if pkgs.stdenv.hostPlatform.isDarwin then "buttonless" else "none";
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

          keyboard.bindings = [
            {
              key = "Enter";
              mods = "Shift";
              chars = promptNewlineChars;
            }
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            {
              key = "Enter";
              mods = "Command";
              chars = promptNewlineChars;
            }
            {
              key = "Slash";
              mods = "Control";
              chars = ''\u001f'';
            }
          ];

          font = {
            size =
              if pkgs.stdenv.hostPlatform.isDarwin then
                config.profile.appearance.fonts.terminalSize.darwin
              else
                config.profile.appearance.fonts.terminalSize.linux;
            normal = {
              inherit (config.profile.appearance.fonts.monospace) family;
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
