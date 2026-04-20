{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      catppuccin = {
        enable = true;
        inherit (config.profile.appearance.catppuccin) flavor;
        inherit (config.profile.appearance.catppuccin) accent;
      };
    };
}
