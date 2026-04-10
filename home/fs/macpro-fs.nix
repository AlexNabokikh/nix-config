{...}: {
  imports = [
    ../modules/home.nix
    ../modules/common.nix
    ../modules/darwin-aerospace.nix
    ../modules/darwin-apps.nix
    # ../modules/darwin-ghostty.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Ensure homebrew is in the PATH
  home.sessionPath = [
    "/opt/homebrew/bin/"
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
