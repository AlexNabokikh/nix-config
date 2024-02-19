{...}: {
  # Install cliphist via home-manager module
  services.cliphist = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };
}
