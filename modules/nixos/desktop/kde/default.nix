{ pkgs, ... }:
let
  wallpaper = ../../../home-manager/misc/wallpaper/wallpaper.jpg;
in
{
  # Enable KDE
  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    settings.Theme.CursorTheme = "Yaru";
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = [
    pkgs.yaru-theme
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${wallpaper};
      type=image
    '')
  ];

  # Excluding some KDE applications from the default install
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    baloo-widgets
    elisa
    ffmpegthumbs
    kate
    khelpcenter
    konsole
    krdp
    plasma-browser-integration
  ];

  # Disabled redundant services
  systemd.user.services = {
    "app-org.kde.discover.notifier@autostart".enable = false;
    "app-org.kde.kalendarac@autostart".enable = false;
  };
}
