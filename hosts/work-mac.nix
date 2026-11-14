{
  imports = [
    ../modules/darwin/aerospace.nix
  ];

  user.name = "alexander.nabokikh";
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 7;
}
