{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.arcane;
in {
  options.services.arcane = {
    enable = mkEnableOption "Arcane container management UI";
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/arcane";
      description = "Data directory for Arcane";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.arcane = {
      image = "ghcr.io/getarcaneapp/arcane:latest";
      ports = [
        "3552:3552"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        "${cfg.dataDir}:/app/data"
      ];
      environment = {
        APP_URL = "https://arcane.krapulax.dev";
        PUID = "1000";
        PGID = "1000";
        # Generate with: openssl rand -hex 32
        ENCRYPTION_KEY = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";
        JWT_SECRET = "fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.arcane.rule" = "Host(`arcane.krapulax.dev`)";
        "traefik.http.routers.arcane.entrypoints" = "web";
        "traefik.http.services.arcane.loadbalancer.server.port" = "3552";
      };
      autoStart = true;
    };

    networking.firewall.allowedTCPPorts = [
      3552
    ];
  };
}
