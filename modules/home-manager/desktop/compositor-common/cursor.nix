{ ... }:
{
  flake.modules.homeManager.desktopCompositorCommon =
    { config, ... }:
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = config.profile.appearance.cursorTheme.package;
        name = config.profile.appearance.cursorTheme.name;
        size = config.profile.appearance.cursorTheme.size;
      };
    };
}
