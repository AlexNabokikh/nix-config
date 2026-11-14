{
  imports = [
    ./hardware.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/gaming.nix
  ];

  user.name = "nabokikh";
  system.stateVersion = "26.05";
}
