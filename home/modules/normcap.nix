{pkgs, ...}: {
  # Ensure normcap package installed
  home.packages = with pkgs; [
    normcap
  ];
}
