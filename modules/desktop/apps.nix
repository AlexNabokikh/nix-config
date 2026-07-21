{
  flake.modules.nixos.desktopApps = {
    services = {
      gvfs.enable = true;
      udisks2.enable = true;
    };
  };

  flake.modules.homeManager.desktopApps =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        file-roller
        gnome-calculator
        gnome-pomodoro
        gnome-text-editor
        loupe
        nautilus
        pavucontrol
        seahorse
        showtime
      ];

      dconf.settings = {
        "org/gnome/calculator" = {
          accuracy = 9;
          angle-units = "degrees";
          base = 10;
          button-mode = "basic";
          number-format = "automatic";
          show-thousands = false;
          show-zeroes = false;
          source-units = [ "degree" ];
          target-units = [ "radian" ];
          window-maximized = false;
        };

        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          search-filter-time-type = "last_modified";
        };
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplicationPackages = [
          pkgs.gnome-text-editor
          pkgs.loupe
          pkgs.showtime
        ];
      };
    };
}
