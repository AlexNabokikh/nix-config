{pkgs, ...}: {
  # enables support for Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable security services support for gtklock
  security.polkit.enable = true;
  security.pam.services.gtklock = {};

  # Enable Ozone Wayland support in Chromium and Electron based applications
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # List of Hyprland specific packages
  environment.systemPackages = with pkgs; [
    gnome-text-editor
    gnome.gnome-calculator
    gnome.gnome-clocks
    gnome.gnome-keyring # password and secrets
    gnome.gnome-weather
    gnome.nautilus
    gnome.seahorse # keyring manager
    evince # gnome document viewer
    loupe # image viewer

    brightnessctl
    grim
    gtklock
    hyprpaper
    libnotify
    networkmanagerapplet
    pamixer
    pavucontrol
    slurp
    swappy
    tesseract
    wlr-randr
    wlsunset
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11";
}
