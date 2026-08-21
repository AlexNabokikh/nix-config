{
  flake.modules.homeManager.fzf =
    { lib, pkgs, ... }:
    let
      copyCmd = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy";
    in
    {
      programs.fzf = {
        enable = true;

        historyWidget.command = "";

        defaultOptions = [
          "--bind '?:toggle-preview'"
          "--bind 'ctrl-e:execute(nvim -- {+})'"
          "--bind 'ctrl-y:execute-silent(printf \"%s\\n\" {+} | ${copyCmd})'"
          "--height=40%"
          "--info=inline"
          "--layout=reverse"
          "--marker='✓'"
          "--pointer='▶'"
          "--prompt='~ '"
        ];
      };

      programs.zsh.initContent = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        # macOS terminal/keyboard mapping for ALT-C.
        bindkey 'ć' fzf-cd-widget
      '';
    };
}
