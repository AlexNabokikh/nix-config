{pkgs, ...}: {
  # Zsh shell configuration
  # TODO: replace exa alias with eza once auto-complete fixed
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
      v = "nvim";
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
}
