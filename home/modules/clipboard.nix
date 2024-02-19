{pkgs, ...}: {
  # Install cliphist via home-manager module
  services.cliphist = {
    enable = true;
    package = pkgs.cliphist;
    systemdTarget = "hyprland-session.target";
  };
}
