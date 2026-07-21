{
  flake.modules.homeManager.fzf =
    { lib, pkgs, ... }:
    let
      copyCmd =
        if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "${pkgs.wl-clipboard}/bin/wl-copy";
      fif = pkgs.writeShellApplication {
        name = "fif";
        runtimeInputs = with pkgs; [
          fzf
          ripgrep
        ];
        text = builtins.readFile ./scripts/bin/fif;
      };
      fkill = pkgs.writeShellApplication {
        name = "fkill";
        runtimeInputs =
          with pkgs;
          [
            findutils
            fzf
            gawk
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            procps
          ];
        text = builtins.readFile ./scripts/bin/fkill;
      };
    in
    {
      home.packages = [
        fif
        fkill
      ];

      programs.fzf = {
        enable = true;

        historyWidget.zsh.command = "";

        defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
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
