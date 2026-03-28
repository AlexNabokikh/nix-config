# Module: Raycast
# Purpose: Configures Raycast productivity launcher
# Platform: macOS
_: {
  homebrew.casks = ["raycast"];

  home.sessionVariables = {
    RAYCAST_CONFIG_DIR = "${config.home.homeDirectory}/.config/raycast";
  };
}
