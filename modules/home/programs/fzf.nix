{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  copyCmd = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy";
in
{
  stylix.targets.fzf.enable = true;

  programs.fzf = {
    enable = true;
    historyWidget.command = "";

    defaultOptions = [
      "--bind '?:toggle-preview'"
      "--bind 'ctrl-e:execute(nvim -- {+})'"
      "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCmd})'"
      "--height=40%"
      "--info=inline"
      "--layout=reverse"
      "--marker='✓'"
      "--pointer='▶'"
      "--prompt='~ '"
    ];

    # Match other TUIs: regular text instead of base04 and no rosewater highlight.
    colors = with colors; {
      fg = lib.mkForce base05;
      "fg+" = lib.mkForce base05;
      "bg+" = lib.mkForce base02;
      gutter = base00;
      border = base03;
    };
  };

  programs.zsh.initContent = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
    # macOS terminal/keyboard mapping for ALT-C.
    bindkey 'ć' fzf-cd-widget
  '';
}
