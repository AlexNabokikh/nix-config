{ inputs, ... }:
{
  flake.modules.nixos.catppuccin =
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
