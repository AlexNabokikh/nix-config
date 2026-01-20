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
    totem # Video player

    # Wayland utilities
    gpu-screen-recorder
    libnotify
    pamixer
    pavucontrol
    wtype
  ];
}
