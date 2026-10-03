{
  flake.modules.nixos.zsh =
    { config, ... }:
    {
      programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
      };
      users.users.${config.primaryUser}.shell = config.programs.zsh.package;
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
