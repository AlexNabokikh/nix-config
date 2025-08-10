{ darwinModules, ... }:
{
  imports = [
    "${darwinModules}/common"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;
}
