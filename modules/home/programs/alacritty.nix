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
  stylix.targets.alacritty = {
    enable = true;
    fonts.enable = false;
    opacity.enable = false;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = lib.getExe config.programs.zsh.package;
        args = [
          "-l"
          "-c"
          "tmux new-session -A -s main"
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
        size = if pkgs.stdenv.hostPlatform.isDarwin then 15 else 12;
        # Installed system-wide by fonts.packages in modules/common/base.nix.
        normal.family = "MesloLGS Nerd Font Mono";
      };

      selection = {
        save_to_clipboard = true;
      };
    };
  };
}
