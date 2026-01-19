{ pkgs, ... }:
{
  # Enable GDM display manager
  services.displayManager.gdm.enable = true;

  # Enable Power management support
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Enable Niri
  programs.niri.enable = true;

  # Enable security services
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    gdm.enableGnomeKeyring = true;
  };

  # List of Niri specific packages
  environment.systemPackages = with pkgs; [
    file-roller # archive manager
    gnome-calculator
    gnome-pomodoro
    gnome-text-editor
    loupe # image viewer
    nautilus # file manager
    seahorse # keyring manager
    totem # Video player

    gpu-screen-recorder
    libnotify
    pamixer
    pavucontrol
  ];
}
