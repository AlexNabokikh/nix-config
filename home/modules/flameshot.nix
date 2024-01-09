{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Ensure flameshot package installed
  home.packages = with pkgs; [
    flameshot
  ];

  # Set env vars so flameshot works under wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
