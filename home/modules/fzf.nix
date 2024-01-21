{...}: {
  # Install fzf via home-manager module
  programs.fzf.enable = true;

  # Set fzf options via env vars
  home.sessionVariables = {
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
    --bind 'ctrl-y:execute-silent(echo {+} | wl-copy)'
    --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
    ";
  };
}
