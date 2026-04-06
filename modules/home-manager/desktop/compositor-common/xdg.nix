{ ... }:
{
  flake.modules.homeManager.desktopCompositorXdg =
    { pkgs, ... }:
    {
      xdg = {
        enable = true;

        desktopEntries = {
          uuctl = {
            name = "uuctl";
            noDisplay = true;
          };
          qt6ct = {
            name = "qt6ct";
            noDisplay = true;
          };
          kvantummanager = {
            name = "kvantum";
            noDisplay = true;
          };
        };

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
