{pkgs, ...}: {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 10;
    terminal = "screen-256color";
    historyLimit = 10000;

    plugins = with pkgs; [
      tmuxPlugins.catppuccin
    ];

    extraConfig = ''
      set -g prefix C-q
      unbind C-b
      setw -g mode-keys vi
      set -g mouse on

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
  };
}
