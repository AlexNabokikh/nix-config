{ inputs, config, ... }:
let
  inherit (config.flake.modules) generic;
in
{
  # Catppuccin colors helper, shared by NixOS and Home Manager modules
  flake.modules.generic.catppuccinColor =
    { config, lib, ... }:
    let
      palette = lib.importJSON "${inputs.catppuccin-palette}/palette.json";
      flavorColors = palette.${config.profile.appearance.catppuccin.flavor}.colors;
    in
    {
      _module.args.catppuccinColor = name: flavorColors.${name}.hex;
    };

  flake.modules.homeManager.catppuccin =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin;

      catppuccinSources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
        _: _: {
          whiskers = pkgs.catppuccin-whiskers;
        }
      );
    in
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        generic.catppuccinColor
      ];

      catppuccin = {
        enable = true;
        autoEnable = true;
        inherit (catppuccin) flavor accent;
        sources = catppuccinSources;
      };
    };
}
