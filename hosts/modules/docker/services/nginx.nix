{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.nginx-web;
in {
  options.services.nginx-web = {
    enable = mkEnableOption "Nginx web server";
    ports = mkOption {
      type = types.listOf types.str;
      default = ["80:80" "443:443"];
      description = "Ports to expose";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/nginx";
      description = "Data directory for nginx";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.nginx = {
      image = "nginx:latest";
      ports = cfg.ports;
      volumes = [
        "${cfg.dataDir}/html:/usr/share/nginx/html:ro"
      ];
      autoStart = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
