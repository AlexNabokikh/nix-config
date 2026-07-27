{
  flake.modules.homeManager.cursor =
    { config, ... }:
    {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        inherit (config.profile.appearance.cursorTheme) package name size;
      };
    };
}
