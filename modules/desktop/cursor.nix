{
  flake.modules.homeManager.cursor =
    { config, ... }:
    {
      catppuccin.cursors.enable = false;

      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        inherit (config.profile.appearance.cursorTheme) package name size;
      };
    };
}
