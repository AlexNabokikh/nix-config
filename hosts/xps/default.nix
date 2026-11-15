{
  imports = [
    ./hardware.nix
    ../../modules/nixos/base.nix
  ];

  networking.hostName = "xps";
  user.name = "nabokikh";
  system.stateVersion = "26.05";

  services.thermald.enable = true;
}
