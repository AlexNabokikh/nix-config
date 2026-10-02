{
  flake.modules.nixos.zsh =
    { config, pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
      };
      users.users.${config.primaryUser}.shell = pkgs.zsh;
    };

  flake.modules.darwin.zsh = {
    programs.zsh.enableGlobalCompInit = false;
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
        defaultKeymap = "viins";
        initContent = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
          open() {
            xdg-open "$@" </dev/null >/dev/null 2>&1 &!
          }
        '';
      };
    };
}
