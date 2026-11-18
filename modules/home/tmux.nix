{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    focusEvents = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-q";
    shell = lib.getExe config.programs.zsh.package;
    terminal = "tmux-256color";

    plugins = [
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          # Preserve Atuin's own navigation keys alongside Vim and fzf.
          set -g @vim_navigator_pattern '(\S+/)?g?\.?(view|l?n?vim?x?|fzf|atuin)(diff)?(-wrapped)?'
        '';
      }
    ];

    extraConfig = ''
      # Derive tmux's UI colours directly from terminal ANSI colours.
      set -s theme terminal

      # Minimal centered status bar on the terminal background.
      set -g status-style "bg=default,fg=brightblack"
      set -g status-justify absolute-centre
      set -g status-left ""
      set -g status-right ""
      set -g window-status-separator " • "
      set -g window-status-format " #I #W "
      set -g window-status-current-format " #I #W#{?window_zoomed_flag, #[fg=blue]󰊓,} "
      set -g window-status-current-style "fg=white,bold"

      # Muted inactive borders and rounded popups on the terminal background.
      set -g pane-border-style "fg=brightblack"
      set -g popup-style default
      set -g popup-border-style "fg=brightblack"
      set -g popup-border-lines rounded

      # Allow applications inside tmux to copy to the system clipboard
      set -s set-clipboard on
      # Forward tmux-wrapped terminal sequences, including clipboard requests
      set -g allow-passthrough on

      # Split panes while preserving the current directory
      unbind '"'
      unbind %
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"

      # Rename window with prefix + r
      bind r command-prompt -I "#W" { rename-window -- "%%" }

      # Reload tmux config by pressing prefix + R
      bind R source-file "${config.xdg.configHome}/tmux/tmux.conf" \; display "TMUX Conf Reloaded"

      # Open project selector in a popup
      bind -n C-f display-popup -E cd-to-project
    '';
  };
}
