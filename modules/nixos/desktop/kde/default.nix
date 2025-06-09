{pkgs, ...}: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    ark
    baloo-widgets # baloo information in Dolphin
    elisa
    ffmpegthumbs
    kate
    khelpcenter
    konsole
    krdp
    plasma-browser-integration
    xwaylandvideobridge # exposes Wayland windows to X11 screen capture
  ];
}
