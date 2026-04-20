{
  flake.modules.darwin.base =
    { config, ... }:
    {
      fonts.packages = [
        config.profile.appearance.fonts.terminal.package
      ];
    };
}
