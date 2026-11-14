{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../common/base.nix
    ./keyboard.nix
    ./system-preferences.nix
    ./users.nix
  ];
}
