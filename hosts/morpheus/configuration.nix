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

  # Morpheus-specific networking (DHCP for now, can be changed to static later)
  systemd.network = {
    enable = lib.mkForce true;
    networks."10-lan" = {
      matchConfig.Name = [
        "en*"
        "eth*"
      ];
      networkConfig.DHCP = "yes";
    };
  };
}
