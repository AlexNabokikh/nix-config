{ config, ... }:
let
  inherit (config.flake.modules) generic nixos;
in
{
  imports = [
    ./nix.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./bluetooth.nix
    ./services.nix
    ./audio.nix
    ./users.nix
    ./packages.nix
    ./containers.nix
    ./fonts.nix
  ];

  flake.modules.nixos.base = {
    imports = [
      generic.profile
      nixos.nix
      nixos.boot
      nixos.networking
      nixos.locale
      nixos.bluetooth
      nixos.services
      nixos.audio
      nixos.users
      nixos.packages
      nixos.containers
      nixos.fonts
    ];
  };
}
