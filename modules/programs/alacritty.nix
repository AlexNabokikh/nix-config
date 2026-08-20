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
    in
    {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal.shell = {
            program = "${pkgs.zsh}/bin/zsh";
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
              if pkgs.stdenv.hostPlatform.isDarwin then
                config.profile.appearance.fonts.terminalSize.darwin
              else
                config.profile.appearance.fonts.terminalSize.linux;
            normal = {
              inherit (config.profile.appearance.fonts.monospace) family;
            };
          };

          selection = {
            save_to_clipboard = true;
          };
        };
      };
    };
}
