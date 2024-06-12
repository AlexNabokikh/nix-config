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
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-shell-extensions
      gnome-terminal
      hitori # sudoku game
      iagno # go game
      simple-scan
      tali # poker game
    ]);

  # List of Gnome specific packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.pomodoro
    gnomeExtensions.auto-move-windows
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.pop-shell
    # gnomeExtensions.space-bar
    # gnomeExtensions.unblank
    gnomeExtensions.user-themes
    (pkgs.callPackage ../../files/custom_pkgs/rounded-window-corners-reborn.nix {})
  ];
}
