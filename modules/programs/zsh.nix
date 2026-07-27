{
  flake.modules.nixos.zsh =
    { config, pkgs, ... }:
    {
      programs.zsh.enable = true;
      users.users.${config.primaryUser}.shell = pkgs.zsh;
    };

  flake.modules.homeManager.zsh =
    {
      lib,
      pkgs,
      ...
    }:
    {
      catppuccin.zsh-syntax-highlighting.enable = false;

      programs.zsh = {
        enable = true;
        initContent = ''
          # bindings
          bindkey -e
          bindkey '^H' backward-delete-word
          bindkey '^[[1;5C' forward-word
          bindkey '^[[1;5D' backward-word

          # open commands in $EDITOR with C-v
          autoload -z edit-command-line
          zle -N edit-command-line
          bindkey "^v" edit-command-line
        ''
        + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
          open() {
            xdg-open "$@" </dev/null >/dev/null 2>&1 &!
          }
        '';
      };
    };
}
