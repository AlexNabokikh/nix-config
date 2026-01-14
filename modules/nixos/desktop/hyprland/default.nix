{ pkgs, ... }:
{
  # Enable GDM display manager
  services.displayManager.gdm.enable = true;

  # Call dbus-update-activation-environment on login
  services.xserver.updateDbusEnvironment = true;

  # Enable Power management support
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Enable security services
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    gdm.enableGnomeKeyring = true;
  };

  # List of Hyprland specific packages
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
    grim
    grimblast
    hypridle
    hyprpicker
    libnotify
    pamixer
    pavucontrol
    slurp
  ];
}
