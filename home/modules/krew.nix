{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # List of packages installed for the user
  home.packages = with pkgs; [
    krew
  ];

  # Adding krew to a session PATH
  home.sessionPath = [
    "$HOME/.krew/bin"
  ];
}
