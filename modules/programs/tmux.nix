{
  flake.modules.homeManager.tmux =
    { config, pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        focusEvents = true;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-q";
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "tmux-256color";

        extraConfig = ''
          # Split panes while preserving the current directory
          unbind '"'
          unbind %
          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"

          # Resize panes with Shift+Arrow
          bind -n S-Down resize-pane -D 8
          bind -n S-Up resize-pane -U 8
          bind -n S-Left resize-pane -L 8
          bind -n S-Right resize-pane -R 8

          # Rename window with prefix + r
          bind r command-prompt -I "#W" "rename-window '%%'"

          # Reload tmux config by pressing prefix + R
          bind R source-file "${config.xdg.configHome}/tmux/tmux.conf" \; display "TMUX Conf Reloaded"

          # Clear screen with prefix + C-l
          bind C-l send-keys 'C-l'

          # Open project selector in a popup
          bind -n C-f display-popup -E cd-to-project

          # Smart pane switching with awareness of Vim splits
          vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf|atuin)(diff)?(-wrapped)?'
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +''${vim_pattern}$'"

          bind -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
          bind -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
          bind -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
          bind -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

          bind -T copy-mode-vi 'C-h' select-pane -L
          bind -T copy-mode-vi 'C-j' select-pane -D
          bind -T copy-mode-vi 'C-k' select-pane -U
          bind -T copy-mode-vi 'C-l' select-pane -R

          # Compose status line after Catppuccin has loaded
          set -g status-right-length 100
          set -g status-right "#{E:@catppuccin_status_host}#{E:@catppuccin_status_date_time}"
          set -g status-left ""
        '';
      };

      catppuccin.tmux.extraConfig = ''
        set -g @catppuccin_status_background "none"
        set -g @catppuccin_window_current_number_color "#{@thm_peach}"
        set -g @catppuccin_window_current_text " #W"
        set -g @catppuccin_window_current_text_color "#{@thm_bg}"
        set -g @catppuccin_window_number_color "#{@thm_blue}"
        set -g @catppuccin_window_text " #W"
        set -g @catppuccin_status_left_separator "█"
        set -g @catppuccin_status_right_separator "█"
      '';
    };
}
