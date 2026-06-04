# Host Configuration: neo
# Purpose: MacBook Pro specific settings
# Platform: macOS (Apple Silicon)
{userConfig, ...}: {
  imports = [
    ../modules/avatar.nix
    ../modules/darwin-common.nix
    ../modules/mac-common.nix
    ../modules/parallels.nix
  ];

  # Enable TouchID and WatchID authentication for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
    reattach = true;
    enable = true;
  };

  # Machine-specific dock settings
  system.defaults.dock = {
    orientation = "left";
    autohide = false;
    persistent-apps = [
      # "/Applications/cmux.app"
      "/Applications/LM Studio.app"
      "/Applications/1Password.app"
      "/Applications/Brave Browser.app"
      "/Applications/Commander One.app"
      # "/Applications/Kiro.app"
      # "/Applications/Lens.app"
      "/Applications/OrbStack.app"
      "/Applications/Parallels Desktop.app"
      "/Applications/Safari.app"
      "/Applications/Termius.app"
      "/Applications/Warp.app"
      "/Applications/WhatsApp.app"
      "/Applications/Cursor.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/OpenCode.app"
    ];
  };

  # Declare primary user
  system.primaryUser = "${userConfig.name}";

  # Set hostname
  networking.hostName = "neo";

  # System state version
  system.stateVersion = 5;
}
