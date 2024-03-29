{pkgs, ...}: {
  # Enable GNOME
  services.xserver.desktopManager.gnome.enable = true;

  # Excluding some GNOME applications from the default install
  environment.gnome.excludePackages =
    (with pkgs; [
      gedit
      gnome-photos
      gnome-tour
      snapshot
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gnome-contacts
      simple-scan
      gnome-maps
      epiphany # web browser
      geary # email reader
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # List of Gnome specific packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks
    gnome.pomodoro
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.pop-shell
    gnomeExtensions.space-bar
    gnomeExtensions.unblank
    gnomeExtensions.user-themes
  ];
}
