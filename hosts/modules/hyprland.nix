{
  inputs,
  pkgs,
  ...
}: {
  # Call dbus-update-activation-environment on login
  services.xserver.updateDbusEnvironment = true;

  # Enables support for Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Enable security services support for gtklock
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    gtklock = {};
    gdm.enableGnomeKeyring = true;
  };
  #
  # Enable Ozone Wayland support in Chromium and Electron based applications
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # List of Hyprland specific packages
  environment.systemPackages = with pkgs; [
    evince # gnome document viewer
    gnome-text-editor
    gnome.file-roller # archive manager
    gnome.gnome-calculator
    gnome.gnome-weather
    gnome.nautilus # file manager
    gnome.pomodoro
    gnome.seahorse # keyring manager
    gnome.totem # Video player
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
    wf-recorder
    wlr-randr
    wlsunset
  ];
}
