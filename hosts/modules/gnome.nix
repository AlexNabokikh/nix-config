{pkgs, ...}: {
  # Enable GNOME
  services.xserver.desktopManager.gnome.enable = true;

  # Remove decorations for QT applications
  environment.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Excluding some GNOME applications from the default install
  environment.gnome.excludePackages =
    (with pkgs; [
      gedit
      gnome-connections
      gnome-console
      gnome-photos
      gnome-tour
      snapshot
    ])
    ++ (with pkgs.gnome; [
      atomix # puzzle game
      baobab # disk usage analyzer
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-disk-utility
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-shell-extensions
      gnome-system-monitor
      gnome-terminal
      gnome-weather
      hitori # sudoku game
      iagno # go game
      simple-scan
      tali # poker game
      yelp # help viewer
    ]);

  # List of Gnome specific packages
  environment.systemPackages = with pkgs.unstable; [
    gnome.gnome-tweaks
    gnome.pomodoro
    gnomeExtensions.auto-move-windows
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.pop-shell
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.space-bar
    gnomeExtensions.unblank
    gnomeExtensions.user-themes
  ];
}
