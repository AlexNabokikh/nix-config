{
  flake.modules.homeManager.tmux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        focusEvents = true;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-q";
        shell = lib.getExe pkgs.zsh;
        terminal = "tmux-256color";

        plugins = [
          {
            plugin = pkgs.tmuxPlugins.dotbar;
            extraConfig = with colors; ''
              set -g @tmux-dotbar-bg "${base00}"
              set -g @tmux-dotbar-fg "${base03}"
              set -g @tmux-dotbar-fg-current "${base05}"
              set -g @tmux-dotbar-fg-prefix "${base0E}"
              set -g @tmux-dotbar-bold-current-window true
              set -g @tmux-dotbar-left false
              set -g @tmux-dotbar-right false
              set -g @tmux-dotbar-window-status-format " #I #W "

              # Preserve numbered window names during SSH sessions.
              set -g @tmux-dotbar-ssh-icon-only true
              # Use our blue instead of dotbar's hard-coded zoom icon colour.
              set -g @tmux-dotbar-maximized-icon "#[fg=${base0D}]󰊓"
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

        extraConfig = with colors; ''
          # Match tmux's menus and other UI elements to the shared terminal palette.
          set -s theme dark
          set -s dark-theme-black "${base00}"
          set -s dark-theme-dark-grey "${base01}"
          set -s dark-theme-light-grey "${base03}"
          set -s dark-theme-white "${base05}"
          set -s dark-theme-red "${base08}"
          set -s dark-theme-yellow "${base0A}"
          set -s dark-theme-green "${base0B}"
          set -s dark-theme-cyan "${base0C}"
          set -s dark-theme-blue "${base0D}"
          set -s dark-theme-magenta "${base0E}"

          set -g window-status-current-style default
          set -g pane-border-style "fg=${base02}"
          # Retain tmux's state colours, with blue for the normal active pane.
          set -g pane-active-border-style "fg=#{?pane_modal_flag,themeblue,#{?pane_marked,thememagenta,#{?synchronize-panes,themered,#{?pane_in_mode,themeyellow,themeblue}}}}"
          set -g message-style "bg=${base01},fg=${base05}"
          set -g message-command-style "bg=${base01},fg=${base0E}"
          set -g mode-style "bg=${base02},fg=${base05}"
          set -g display-panes-colour "${base03}"
          set -g display-panes-active-colour "${base0D}"

          # Allow applications inside tmux to copy to the system clipboard
          set -s set-clipboard on
          # Forward tmux-wrapped terminal sequences, including clipboard requests
          set -g allow-passthrough on

          # Share the fzf background and use rounded popup borders.
          set -g popup-style "bg=${base00},fg=${base05}"
          set -g popup-border-style "bg=${base00},fg=${base03}"
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
    };
}
