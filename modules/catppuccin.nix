{ inputs, ... }:
{
  flake.modules.homeManager.catppuccin =
    { config, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        enable = true;
        inherit (config.profile.appearance.catppuccin) flavor accent;
      };
    };
}
