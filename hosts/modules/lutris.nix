{pkgs, ...}: {
  # Lutris game launcher
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
  ];
}
