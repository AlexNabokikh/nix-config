{ ... }:
{
  flake.modules.homeManager.desktopXdg =
    { pkgs, ... }:
    {
      xdg = {
        enable = true;

        mimeApps = {
          enable = true;
          defaultApplicationPackages = [
            pkgs.gnome-text-editor
            pkgs.loupe
            pkgs.showtime
          ];
        };

        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };
}
