{pkgs, ...}: {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    catppuccin = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_window_left_separator "█"
        set -g @catppuccin_window_right_separator "█ "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"
        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"
        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W"
        set -g @catppuccin_status_modules_right "host date_time"
        set -g @catppuccin_status_left_separator "█"
        set -g @catppuccin_status_right_separator "█"
        set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"
      '';
    };
    escapeTime = 10;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.unstable; [
      {plugin = tmuxPlugins.vim-tmux-navigator;}
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

      # Bind Arrow keys to resize the window
      bind -n S-Down resize-pane -D 8
      bind -n S-Up resize-pane -U 8
      bind -n S-Left resize-pane -L 8
      bind -n S-Right resize-pane -R 8

      # Rename window with prefix + r
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
