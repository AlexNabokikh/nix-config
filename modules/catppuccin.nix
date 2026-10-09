{ inputs, ... }:
{
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
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        enable = true;
        autoEnable = true;
        inherit (catppuccin) flavor accent;
        sources = catppuccinSources;
      };
    };
}
