{ ... }:
{
  flake.modules.homeManager.baseCatppuccin =
    { config, ... }:
    {
      catppuccin = {
        enable = true;
        flavor = config.profile.appearance.catppuccin.flavor;
        accent = config.profile.appearance.catppuccin.accent;
      };
    };
}
