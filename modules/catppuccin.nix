{ inputs, ... }:
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      catppuccin = {
        cache.enable = true;
        inherit (config.profile.appearance.catppuccin) flavor accent;
      };
    };

  flake.modules.homeManager.base =
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
