{ inputs, ... }:
{
  flake.modules.homeManager.catppuccin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin;

      catppuccinSources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
        final: prev: {
          whiskers = pkgs.catppuccin-whiskers;
        }
      );
      palette = lib.importJSON "${inputs.catppuccin-palette}/palette.json";
      flavorColors = palette.${catppuccin.flavor}.colors;
    in
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      # Catppuccin colors helper
      _module.args.catppuccinColor = name: flavorColors.${name}.hex;

      catppuccin = {
        enable = true;
        autoEnable = true;
        inherit (config.profile.appearance.catppuccin) flavor accent;
        sources = catppuccinSources;
      };
    };
}
