{
  imports = [
    ./hardware.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/gaming.nix
  ];

  networking.hostName = "energy";
  user.name = "nabokikh";
  system.stateVersion = "26.05";
}
