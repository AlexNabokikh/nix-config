{
  imports = [ ./hardware.nix ];

  user.name = "nabokikh";
  system.stateVersion = "26.05";

  services.thermald.enable = true;
}
