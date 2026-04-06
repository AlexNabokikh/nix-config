{ ... }:
{
  flake.modules.darwin.fonts =
    { config, ... }:
    {
      fonts.packages = [
        config.profile.appearance.fonts.terminal.package
      ];
    };
}
