{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.traefik-docker;
  omniCfg = config.services.omni-docker;
  cfApiToken = builtins.getEnv "TRAEFIK_CLOUDFLARE_API_TOKEN";
  cfZoneId = builtins.getEnv "TRAEFIK_CLOUDFLARE_ZONE_ID";
  cfEmail = builtins.getEnv "TRAEFIK_CLOUDFLARE_EMAIL";

  omniDynamicConfig = pkgs.writeText "traefik-omni-dynamic.yml" ''
    http:
      routers:
        omni:
          rule: Host(`${omniCfg.hostname}`)
          entryPoints:
            - web
          service: omni
        omni-secure:
          rule: Host(`${omniCfg.hostname}`)
          entryPoints:
            - websecure
          service: omni
          tls: {}
        omni-auth:
          rule: Host(`${omniCfg.authHostname}`)
          entryPoints:
            - web
          service: omni-auth
        omni-auth-secure:
          rule: Host(`${omniCfg.authHostname}`)
          entryPoints:
            - websecure
          service: omni-auth
          tls: {}
      services:
        omni:
          loadBalancer:
            serversTransport: omni-insecure
            servers:
              - url: https://host.docker.internal:8443
        omni-auth:
          loadBalancer:
            serversTransport: omni-insecure
            servers:
              - url: https://host.docker.internal:5556
      serversTransports:
        omni-insecure:
          insecureSkipVerify: true
    tls:
      certificates:
        - certFile: /etc/traefik/omni/server-chain.pem
          keyFile: /etc/traefik/omni/server-key.pem
  '';
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
      volumes =
        [
          "/var/lib/traefik:/etc/traefik:rw"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ]
        ++ optionals omniCfg.enable [
          "${omniDynamicConfig}:/etc/traefik/dynamic/omni.yml:ro"
          "${omniCfg.secretsDir}/server-chain.pem:/etc/traefik/omni/server-chain.pem:ro"
          "${omniCfg.secretsDir}/server-key.pem:/etc/traefik/omni/server-key.pem:ro"
        ];
      environment = {
        CF_API_TOKEN = cfApiToken;
        CF_ZONE_ID = cfZoneId;
        CF_EMAIL = cfEmail;
      };
      cmd =
        [
          "--api"
          "--providers.docker"
          "--providers.docker.exposedbydefault=false"
          "--entrypoints.web.address=:80"
          "--entrypoints.websecure.address=:443"
          "--serversTransport.insecureSkipVerify=true"
          "--log.level=DEBUG"
        ]
        ++ optionals omniCfg.enable [
          "--providers.file.directory=/etc/traefik/dynamic"
          "--providers.file.watch=true"
        ];
      extraOptions = optionals omniCfg.enable [
        "--add-host=host.docker.internal:host-gateway"
      ];
      autoStart = true;
    };
  };
}
