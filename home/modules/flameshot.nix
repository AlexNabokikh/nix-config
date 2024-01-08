{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # List of packages installed for the user
  home.packages = with pkgs; [
    flameshot
  ];

  # Environment session variables
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
