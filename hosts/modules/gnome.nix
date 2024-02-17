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
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-dock
    gnomeExtensions.forge
    gnomeExtensions.just-perfection
    gnomeExtensions.space-bar
    gnomeExtensions.unblank
    gnomeExtensions.user-themes
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11";
}
