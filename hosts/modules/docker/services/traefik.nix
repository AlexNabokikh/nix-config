{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.traefik-docker;
  cfApiToken = builtins.getEnv "TRAEFIK_CLOUDFLARE_API_TOKEN";
  cfZoneId = builtins.getEnv "TRAEFIK_CLOUDFLARE_ZONE_ID";
  cfEmail = builtins.getEnv "TRAEFIK_CLOUDFLARE_EMAIL";
in {
  options.services.traefik-docker = {
    enable = mkEnableOption "Traefik reverse proxy (docker)";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.traefik = {
      image = "traefik:v2.11";
      ports = [
        "80:80"
        "443:443"
        "8080:8080"
      ];
      volumes = [
        "/var/lib/traefik:/etc/traefik:rw"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        CF_API_TOKEN = cfApiToken;
        CF_ZONE_ID = cfZoneId;
        CF_EMAIL = cfEmail;
      };
      cmd = [
        "--api"
        "--providers.docker"
        "--providers.docker.exposedbydefault=false"
        "--entrypoints.web.address=:80"
        "--log.level=DEBUG"
      ];
      autoStart = true;
    };
  };
}
