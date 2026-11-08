{
  # Only the terminal font is managed; everything else uses the desktop's defaults.
  flake.modules.generic.fonts =
    { config, ... }:
    {
      fonts.packages = [ config.profile.appearance.terminalFont.package ];
    };
}
