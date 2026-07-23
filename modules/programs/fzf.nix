{
  flake.modules.homeManager.fzf =
    { lib, pkgs, ... }:
    let
      copyCmd = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy";
    in
    {
      programs.fzf = {
        enable = true;

        historyWidget.zsh.command = "";

        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        defaultOptions = [
          "--bind '?:toggle-preview'"
          "--bind 'ctrl-e:execute(nvim -- {+})'"
          "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCmd})'"
          "--height=40%"
          "--info=inline"
          "--layout=reverse"
          "--preview '( [[ -f {} ]] && (bat --color=always --style=numbers,changes {} || cat {}) || [[ -d {} ]] && eza --all --long --color=always {} || echo {} ) 2> /dev/null | head -200'"
          "--preview-window=:hidden"
          "--prompt='~ ' --pointer='▶' --marker='✓'"
        ];
      };

      programs.zsh.initContent = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        # Enable ALT-C fzf keybinding on Mac
        bindkey 'ć' fzf-cd-widget
      '';
    };
}
