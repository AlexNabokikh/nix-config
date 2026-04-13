{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.beszel;
  agentKey = builtins.getEnv "BESZEL_AGENT_KEY";
  agentToken = builtins.getEnv "BESZEL_AGENT_TOKEN";
in {
  options.services.beszel = {
    enable = mkEnableOption "Beszel server monitoring";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.beszel = {
      image = "henrygd/beszel:latest";
      ports = [
        "8090:8090"
      ];
      volumes = [
        "${config.users.users.fs.home}/beszel/data:/beszel_data"
        "${config.users.users.fs.home}/beszel/socket:/beszel_socket"
      ];
      environment = {
        APP_URL = "https://beszel.krapulax.dev";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.beszel.rule" = "Host(`beszel.krapulax.dev`)";
        "traefik.http.routers.beszel.entrypoints" = "web";
        "traefik.http.services.beszel.loadbalancer.server.port" = "8090";
      };
      autoStart = true;
    };

    virtualisation.oci-containers.containers.beszel-agent = mkIf (agentKey != "" && agentToken != "") {
      image = "henrygd/beszel-agent:latest";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        "${config.users.users.fs.home}/beszel/socket:/beszel_socket"
      ];
      environment = {
        LISTEN = "/beszel_socket/beszel.sock";
        HUB_URL = "http://localhost:8090";
        KEY = agentKey;
        TOKEN = agentToken;
      };
      extraOptions = [
        "--network=host"
      ];
      autoStart = true;
    };
  };
}
