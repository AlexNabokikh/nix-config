{
  inputs,
  hostname,
  lib,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    ../vm-generic/configuration.nix
  ];

  # Morpheus-specific networking (static IP)
  systemd.network = {
    enable = lib.mkForce true;
    networks."10-lan" = {
      matchConfig.Name = [
        "en*"
        "eth*"
      ];
      address = ["10.0.40.101/24"];
      gateway = ["10.0.40.1"];
      dns = ["1.1.1.1" "1.0.0.1"];
      networkConfig.DHCP = "no";
    };
  };
}
