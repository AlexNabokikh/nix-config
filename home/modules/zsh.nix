{inputs, ...}: {
  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    syntaxHighlighting.enable = true;

    # Optional: Use zsh-autosuggestions and zsh-history-substring-search plugins
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = inputs.zsh-autosuggestions;
      }
      {
        name = "zsh-history-substring-search";
        src = inputs.zsh-history-substring-search;
      }
    ];

    shellAliases = {
      cd = "__zoxide_z";
      ff = "fastfetch";
      ld = "lazydocker";
      lg = "lazygit";
      repo = "cd $HOME/Documents/repositories";
      temp = "cd $HOME/Downloads/temp";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree

      # Git aliases
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";

      # Kubectl aliases
      k = "kubectl";
      kgno = "kubectl get node";
      kdno = "kubectl describe node";
      kgp = "kubectl get pods";
      kep = "kubectl edit pods";
      kdp = "kubectl describe pods";
      kdelp = "kubectl delete pods";
      kgs = "kubectl get svc";
      kes = "kubectl edit svc";
      kds = "kubectl describe svc";
      kdels = "kubectl delete svc";
      kgi = "kubectl get ingress";
      kei = "kubectl edit ingress";
      kdi = "kubectl describe ingress";
      kdeli = "kubectl delete ingress";
      kgns = "kubectl get namespaces";
      kens = "kubectl edit namespace";
      kdns = "kubectl describe namespace";
      kdelns = "kubectl delete namespace";
      kgd = "kubectl get deployment";
      ked = "kubectl edit deployment";
      kdd = "kubectl describe deployment";
      kdeld = "kubectl delete deployment";
      kgsec = "kubectl get secret";
      kdsec = "kubectl describe secret";
      kdelsec = "kubectl delete secret";
    };

    initContent = ''
      # kubectl auto-complete
      source <(kubectl completion zsh)

      # # mise hook
      eval "$(mise activate zsh)"

      # direnv hook
      eval "$(direnv hook zsh)"

      # Load cached Doppler secrets
      # DISABLED: Doppler env vars no longer auto-loaded
      # if [ -f "$HOME/.config/doppler/env.sh" ]; then
      #   set -a
      #   source "$HOME/.config/doppler/env.sh"
      #   set +a
      # fi

      # # 1password CLI integration - ensure 1password CLI is installed #FIXME: this should be fixed and re-integrated but currently allowing this makes the shell constantly asking for login
      # if command -v op &> /dev/null; then
      #   eval "$(op completion zsh)"
      #   eval "$(op signin)"
      # fi

      # bindings
      bindkey -v
      bindkey '^A' beginning-of-line
      bindkey '^E' end-of-line
      bindkey '^H' backward-delete-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      # Enable history substring search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Increase history size and configure history behavior
      export HISTSIZE=10000
      export SAVEHIST=10000
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt SHARE_HISTORY

      # OrbStack shell integration
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
  };
}
