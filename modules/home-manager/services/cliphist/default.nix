{...}: {
  # Install cliphist via home-manager module
  services.cliphist = {
    enable = true;
    systemdTargets = "hyprland-session.target";
  };
}
