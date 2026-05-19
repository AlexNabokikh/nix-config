{
  flake.modules.homeManager.fzf =
    { pkgs, ... }:
    let
      copyCmd = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy";
    in
    {
      programs.fzf = {
        enable = true;

        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        defaultOptions = [
          "--bind '?:toggle-preview'"
          "--bind 'ctrl-a:select-all'"
          "--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"
          "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCmd})'"
          "--height=40%"
          "--info=inline"
          "--layout=reverse"
          "--multi"
          "--preview '([[ -f {} ]] && (bat --color=always --style=numbers,changes {} || cat {})) || ([[ -d {} ]] && (ls -la --color=always {})) || echo {} 2> /dev/null | head -200'"
          "--preview-window=:hidden"
          "--prompt='~ ' --pointer='▶' --marker='✓'"
        ];
      };
    };
}
