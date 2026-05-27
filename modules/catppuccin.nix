{ inputs, ... }:
{
  flake.modules.homeManager.catppuccin =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        enable = true;
        inherit (config.profile.appearance.catppuccin) flavor accent;
        sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
          final: prev: {
            whiskers = pkgs.catppuccin-whiskers;
          }
        );
      };
    };
}
