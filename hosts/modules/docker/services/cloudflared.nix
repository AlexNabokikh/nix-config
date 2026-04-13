{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.cloudflared-tunnel;
in {
  options.services.cloudflared-tunnel = {
    enable = mkEnableOption "Cloudflare Tunnel (docker)";
    secretsDir = mkOption {
      type = types.path;
      default = "/run/secrets/cloudflared";
      description = ''
        Directory containing cloudflared token or credentials files.
      '';
    };
    authMode = mkOption {
      type = types.enum [
        "token"
        "credentials"
      ];
      default = "token";
      description = "Cloudflared authentication mode.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.cloudflared = {
      image = "cloudflare/cloudflared:latest";
      user = "0";
      volumes = [
        "${cfg.secretsDir}:/etc/cloudflared:ro"
      ];
      cmd =
        if cfg.authMode == "token"
        then [
          "tunnel"
          "--no-autoupdate"
          "--config"
          "/etc/cloudflared/config.yml"
          "run"
          "--token-file"
          "/etc/cloudflared/token"
        ]
        else [
          "tunnel"
          "--no-autoupdate"
          "--config"
          "/etc/cloudflared/config.yml"
          "run"
        ];
      extraOptions = [
        "--network=host"
      ];
      autoStart = true;
    };
  };
}
