{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.whoami-docker;
in {
  options.services.whoami-docker = {
    enable = mkEnableOption "Whoami test container for Traefik";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.whoami = {
      image = "traefik/whoami:latest";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.whoami.rule" = "Host(`whoami.krapulax.dev`)";
        "traefik.http.routers.whoami.entrypoints" = "web";
        "traefik.http.services.whoami.loadbalancer.server.port" = "80";
      };
      autoStart = true;
    };
  };
}
