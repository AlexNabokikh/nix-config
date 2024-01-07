{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # Define theme name and configuration for GTK
  catppuccin_name = "Catppuccin-Macchiato-Standard-Lavender-Dark";
  catppuccin = pkgs.catppuccin-gtk.override {
    accents = ["lavender"];
    size = "standard";
    tweaks = ["normal"];
    variant = "macchiato";
  };
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [
    # Spicetify
    inputs.spicetify-nix.homeManagerModule
  ];

  # nixpkgs configuration
  nixpkgs = {
    overlays = [
      (final: prev: {
        ulauncher = prev.ulauncher.overrideAttrs (old: {
          propagatedBuildInputs = with prev.python3Packages;
            old.propagatedBuildInputs
            ++ [
              thefuzz
              tornado
            ];
        });
      })
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "nabokikh";
    homeDirectory = "/home/nabokikh";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # List of packages installed for the user
  home.packages = [
    pkgs.krew
    pkgs.ulauncher
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Ulauncher service configuration
  systemd.user.services.ulauncher = {
    Unit = {
      Description = "ulauncher application launcher service";
      Documentation = "https://ulauncher.io";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -lc '${pkgs.ulauncher}/bin/ulauncher --hide-window --no-window-shadow'";
      Restart = "on-failure";
    };

    Install.WantedBy = ["graphical-session.target"];
  };

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = catppuccin_name;
      package = catppuccin;
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };
  };

  # GTK-4 configuration files
  home.file.".config/gtk-4.0/gtk.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk.css";
  home.file.".config/gtk-4.0/gtk-dark.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";
  home.file.".config/gtk-4.0/assets" = {
    recursive = true;
    source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/assets";
  };

  # Environment session variables
  home.sessionVariables = {
    BAT_THEME = "Catppuccin-macchiato";

    FZF_DEFAULT_COMMAND = "find .";
    FZF_DEFAULT_OPTS = "
    --height=40%
    --layout=reverse
    --info=inline
    --multi
    --preview-window=:hidden
    --preview '([[ -f {}  ]] && (bat --color=always --style=numbers,changes {} || cat {})) || ([[ -d {}  ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
    --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
    --prompt='~ ' --pointer='▶' --marker='✓'
    --bind '?:toggle-preview'
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
    --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
    --bind 'ctrl-v:execute(code {+})'
    ";

    SAML2AWS_SESSION_DURATION = "3600";

    QT_QPA_PLATFORM = "wayland";
  };

  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    shellAliases = {
      cat = "bat -p";
      du = "dust";
      grep = "rg";
      kupdate = "krew update && krew upgrade";
      ld = "lazydocker";
      lg = "lazygit";
      repo = "cd $HOME/Documents/repositories";
      temp = "cd $HOME/Downloads/temp";
      top = "btm";
      vim = "nvim";
      ls = "exa --icons"; # default view
      ll = "exa -bhl --group-directories-first --icons"; # long list
      la = "exa -abhl --group-directories-first --icons"; # all list
      lt = "exa --tree --level=2 --icons"; # tree
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "vi-mode"
      ];
    };
    initExtra = ''
      source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      for conf in "$HOME/.config/zsh/"*.zsh; do
        source "$conf"
      done
      unset conf
    '';
  };

  # Adding krew to a session PATH
  home.sessionPath = [
    "$HOME/.krew/bin"
  ];

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

  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      alejandra
      ansible-language-server
      ansible-lint
      black
      dockerfile-language-server-nodejs
      golangci-lint
      golangci-lint-langserver
      gopls
      gotools
      hadolint
      isort
      lua-language-server
      markdownlint-cli
      marksman
      nodePackages.bash-language-server
      nodePackages.prettier
      nodePackages.pyright
      ruff
      ruff-lsp
      shellcheck
      shfmt
      stylua
      terraform-ls
      tflint
      vscode-langservers-extracted
      yaml-language-server
    ];
  };

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";

    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
