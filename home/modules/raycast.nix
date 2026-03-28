# Module: Raycast
# Purpose: Configures Raycast productivity launcher
# Platform: macOS
{config, ...}: {
  homebrew.casks = ["raycast"];

  home.sessionVariables = {
    RAYCAST_CONFIG_DIR = "${config.home.homeDirectory}/.config/raycast";
  };
}
