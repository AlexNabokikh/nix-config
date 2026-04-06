{ config, ... }:
{
  flake.modules.homeManager.desktopCompositorCursor =
    {
      lib,
      pkgs,
      ...
    }:
    let
      resolvePackage =
        packagePath:
        lib.attrByPath packagePath
          (throw "Profile package path not found: ${lib.concatStringsSep "." packagePath}")
          pkgs;
    in
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = resolvePackage config.profile.appearance.cursorTheme.packagePath;
        name = config.profile.appearance.cursorTheme.name;
        size = config.profile.appearance.cursorTheme.size;
      };
    };
}
