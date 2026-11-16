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
  home.packages = [ pkgs.nerd-fonts.meslo-lg ];

  programs.alacritty = {
    enable = true;
    settings = {
      # Adwaita dark surfaces with Catppuccin Mocha ANSI accents; CLI/TUI tools inherit these via ANSI.
      colors = {
        primary = {
          background = "#1d1d20";
          foreground = "#cdd6f4";
          bright_foreground = "#b4befe";
        };
        cursor = {
          text = "#1d1d20";
          cursor = "#cdd6f4";
        };
        selection = {
          text = "#cdd6f4";
          background = "#2e2e32";
        };
        normal = {
          black = "#1d1d20";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#cba6f7";
          cyan = "#94e2d5";
          white = "#cdd6f4";
        };
        bright = {
          black = "#6c6c70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#cba6f7";
          cyan = "#94e2d5";
          white = "#b4befe";
        };
      };

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
        normal.family = "MesloLGS Nerd Font Mono";
      };

      selection = {
        save_to_clipboard = true;
      };
    };
  };
}
