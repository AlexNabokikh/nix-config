{...}: {
  imports = [
    ../vm-generic/configuration.nix
    ../modules/docker
  ];

  services.nginx-web = {
    enable = true;
  };

  services.arcane = {
    enable = true;
  };
}
