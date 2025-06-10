{pkgs, ...}: let
  wallpaper = ../../../home-manager/misc/wallpaper/wallpaper.jpg;
in {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings.Theme.CursorTheme = "Yaru";
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

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    ark
    baloo-widgets
    elisa
    ffmpegthumbs
    kate
    khelpcenter
    konsole
    krdp
    plasma-browser-integration
    xwaylandvideobridge
  ];
}
