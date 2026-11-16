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
        plugin = pkgs.tmuxPlugins.dotbar;
        extraConfig = ''
          set -g @tmux-dotbar-bg "default"
          set -g @tmux-dotbar-fg "brightblack"
          set -g @tmux-dotbar-fg-current "white"
          set -g @tmux-dotbar-fg-prefix "magenta"
          set -g @tmux-dotbar-bold-current-window true
          set -g @tmux-dotbar-left false
          set -g @tmux-dotbar-right false
          set -g @tmux-dotbar-window-status-format " #I #W "

          # Preserve numbered window names during SSH sessions.
          set -g @tmux-dotbar-ssh-icon-only true
          # Use terminal blue instead of dotbar's hard-coded zoom icon colour.
          set -g @tmux-dotbar-maximized-icon "#[fg=blue]󰊓"
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          # Preserve Atuin's own navigation keys alongside Vim and fzf.
          set -g @vim_navigator_pattern '(\S+/)?g?\.?(view|l?n?vim?x?|fzf|atuin)(diff)?(-wrapped)?'
        '';
      }
    ];

    extraConfig = ''
      # Derive tmux's menus and theme* colours directly from terminal ANSI colours.
      set -s theme terminal

      set -g window-status-current-style default
      set -g pane-border-style "fg=brightblack"
      # Retain tmux's state colours, with blue for the normal active pane.
      set -g pane-active-border-style "fg=#{?pane_modal_flag,themeblue,#{?pane_marked,thememagenta,#{?synchronize-panes,themered,#{?pane_in_mode,themeyellow,themeblue}}}}"
      set -g message-style "bg=black,fg=white"
      set -g message-command-style "bg=black,fg=magenta"
      set -g mode-style "reverse"
      set -g display-panes-colour "brightblack"
      set -g display-panes-active-colour "blue"

      # Allow applications inside tmux to copy to the system clipboard
      set -s set-clipboard on
      # Forward tmux-wrapped terminal sequences, including clipboard requests
      set -g allow-passthrough on

      # Use terminal background and rounded popup borders.
      set -g popup-style "bg=default,fg=default"
      set -g popup-border-style "bg=default,fg=brightblack"
      set -g popup-border-lines rounded

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
