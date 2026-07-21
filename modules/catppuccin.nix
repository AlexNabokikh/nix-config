{ inputs, ... }:
{
  flake.modules.homeManager.catppuccin =
    { config, pkgs, ... }:
    let
      inherit (config.profile.appearance) catppuccin;

      catppuccinSources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
        final: prev: {
          whiskers = pkgs.catppuccin-whiskers;
        }
      );
      paletteFile = "${catppuccinSources.sources.palette}/palette.json";
      palette = builtins.fromJSON (builtins.readFile paletteFile);
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
