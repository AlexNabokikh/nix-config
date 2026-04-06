{ ... }:
{
  flake.modules.nixos.fonts =
    { config, ... }:
    {
      fonts.packages = [
        config.profile.appearance.fonts.ui.package
        config.profile.appearance.fonts.monospace.package
        config.profile.appearance.fonts.terminal.package
      ];
    };
}
