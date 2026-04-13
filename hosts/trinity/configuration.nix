{...}: {
  imports = [
    ../vm-generic/configuration.nix
    ../modules/docker
  ];

  services.arcane = {
    enable = true;
  };

  services.cloudflared-tunnel = {
    enable = true;
  };

  services.traefik-docker = {
    enable = true;
  };

  services.whoami-docker = {
    enable = true;
  };

  services.beszel = {
    enable = true;
  };
}
