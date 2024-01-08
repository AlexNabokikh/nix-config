{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
      ls = "eza --icons"; # default view
      ll = "eza -bhl --group-directories-first --icons"; # long list
      la = "eza -abhl --group-directories-first --icons"; # all list
      lt = "eza --tree --level=2 --icons"; # tree
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
