{
  inputs,
  hostname,
  lib,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    ../modules/nixos-server-common.nix
    ../modules/tailscale.nix
  ];

  networking.hostName = hostname;
  networking.useDHCP = lib.mkForce false;
  networking.networkmanager.ensureProfiles.profiles.morpheus = {
    connection = {
      id = "morpheus";
      type = "ethernet";
      interface-name = "enp3s0";
      autoconnect = true;
    };
    ipv4 = {
      method = "manual";
      addresses = "10.0.40.19/24";
      gateway = "10.0.40.1";
      dns = "1.1.1.1;8.8.8.8;";
    };
    ipv6.method = "ignore";
  };

  tailscale.enable = true;

  services.dbus.implementation = "dbus";

  system.stateVersion = "25.11";
}
