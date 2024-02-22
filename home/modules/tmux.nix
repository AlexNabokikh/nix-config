{pkgs, ...}: {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 10;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'macchiato'
          set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_modules_right "application session user host date_time"
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"
          set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"
        '';
      }
    ];
    extraConfig = ''
      # Set the prefix to `ctrl + q` instead of `ctrl + b`
      set -g prefix C-q
      unbind C-b

      # Use | and - to split a window vertically and horizontally instead of " and % respoectively
      unbind '"'
      unbind %
      bind + split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Bind D to resize the window to be 8 lines smaller
      bind D resize-pane -D 8
      bind U resize-pane -U 4

      # Move around panes with hjkl, as one would in vim after pressing ctrl + q
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Use shift + arrow key to move between windows in a session
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on
      bind r command-prompt -I "#W" "rename-window '%%'"

      # Apply Tc
      set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"

      # Enable focus-events
      set -g focus-events on

      # Set default escape-time
      set-option -sg escape-time 10
    '';
  };
}
