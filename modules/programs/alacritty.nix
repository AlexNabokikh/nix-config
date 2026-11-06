{
  flake.modules.homeManager.alacritty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      promptNewline = ''\u001b\u000d'';
      unitSeparator = ''\u001f'';
      inherit (config.profile.appearance) terminalFont;
    in
    {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal.shell = {
            program = lib.getExe pkgs.zsh;
            args = [
              "-l"
              "-c"
              "tmux attach || tmux"
            ];
          };

          window = {
            decorations = if pkgs.stdenv.hostPlatform.isDarwin then "buttonless" else "none";
            dynamic_padding = true;
            padding = {
              x = 2;
              y = 1;
            };
          };

          keyboard.bindings = [
            {
              key = "Enter";
              mods = "Shift";
              mode = "~Vi|~Search";
              chars = promptNewline;
            }
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            {
              key = "Enter";
              mods = "Command";
              mode = "~Vi|~Search";
              chars = promptNewline;
            }
            {
              key = "Slash";
              mods = "Control";
              mode = "~Vi|~Search";
              chars = unitSeparator;
            }
          ];

          font = {
            size =
              if pkgs.stdenv.hostPlatform.isDarwin then terminalFont.size.darwin else terminalFont.size.linux;
            normal.family = terminalFont.family;
          };

          selection = {
            save_to_clipboard = true;
          };
        };
      };
    };
}
