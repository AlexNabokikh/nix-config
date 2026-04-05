{ ... }:
{
  # NixOS-level Wayland common configuration
  flake.modules.nixos.desktopWaylandCommon =
    { pkgs, ... }:
    {
      # Enable GDM display manager
      services.displayManager.gdm.enable = true;

      # Enable Power management support
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      # Enable security services
      services.gnome.gnome-keyring.enable = true;
      security.polkit.enable = true;
      security.pam.services = {
        gdm.enableGnomeKeyring = true;
      };

      # Common packages for Wayland compositors
      environment.systemPackages = with pkgs; [
        # GNOME apps
        file-roller # archive manager
        gnome-calculator
        gnome-pomodoro
        gnome-text-editor
        loupe # image viewer
        nautilus # file manager
        seahorse # keyring manager
        showtime # Video player

        # Wayland utilities
        gpu-screen-recorder
        grim
        libnotify
        pamixer
        pavucontrol
        slurp
      ];
    };

  # Home-manager-level Wayland common configuration
  flake.modules.homeManager.desktopWaylandCommon =
    {
      config,
      lib,
      ...
    }:
    {
      # Consistent cursor theme across all applications.
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = config.gtk.cursorTheme.package;
        name = config.gtk.cursorTheme.name;
        size = config.gtk.cursorTheme.size;
      };

      dconf.settings = {
        "org/gnome/calculator" = {
          "accuracy" = 9;
          "angle-units" = "degrees";
          "base" = 10;
          "button-mode" = "basic";
          "number-format" = "automatic";
          "show-thousands" = false;
          "show-zeroes" = false;
          "source-currency" = "";
          "source-units" = "degree";
          "target-currency" = "";
          "target-units" = "radian";
          "window-maximized" = false;
        };

        "org/gnome/desktop/wm/preferences" = {
          "button-layout" = lib.mkForce "";
        };

        "org/gnome/nautilus/preferences" = {
          "default-folder-viewer" = "list-view";
          "migrated-gtk-settings" = true;
          "search-filter-time-type" = "last_modified";
          "search-view" = "list-view";
        };

        "org/gtk/gtk4/settings/file-chooser" = {
          "show-hidden" = true;
        };

        "org/gtk/settings/file-chooser" = {
          "date-format" = "regular";
          "location-mode" = "path-bar";
          "show-hidden" = true;
          "show-size-column" = true;
          "show-type-column" = true;
          "sort-column" = "name";
          "sort-directories-first" = false;
          "sort-order" = "ascending";
          "type-format" = "category";
          "view-type" = "list";
        };
      };
    };
}
