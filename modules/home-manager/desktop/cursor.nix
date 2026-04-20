{
  flake.modules.homeManager.desktopCursor =
    { config, ... }:
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        inherit (config.profile.appearance.cursorTheme) package;
        inherit (config.profile.appearance.cursorTheme) name;
        inherit (config.profile.appearance.cursorTheme) size;
      };
    };
}
