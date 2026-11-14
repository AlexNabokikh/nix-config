{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common/base.nix
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./networking.nix
    ./podman.nix
    ./users.nix
  ];
}
