{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Ensure krew package installed
  home.packages = with pkgs; [
    krew
  ];

  # Adding krew to a session PATH
  home.sessionPath = [
    "$HOME/.krew/bin"
  ];
}
