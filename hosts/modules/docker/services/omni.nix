{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.omni-docker;

  envOr = name: default: let
    value = builtins.getEnv name;
  in
    if value != ""
    then value
    else default;
  machineApiPort = last (splitString ":" cfg.machineApiBindAddr);
in {
  options.services.omni-docker = {
    enable = mkEnableOption "Sidero Omni (docker)";

    image = mkOption {
      type = types.str;
      default = "ghcr.io/siderolabs/omni:latest";
      description = "Omni container image.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/omni";
      description = "Persistent Omni data directory.";
    };

    secretsDir = mkOption {
      type = types.path;
      default = "/run/secrets/omni";
      description = "Runtime directory containing Omni TLS, GPG, and Dex secrets.";
    };

    hostname = mkOption {
      type = types.str;
      default = envOr "OMNI_ENDPOINT" "omni.krapulax.dev";
      description = "Public Omni UI hostname.";
    };

    authHostname = mkOption {
      type = types.str;
      default = envOr "OMNI_AUTH_ENDPOINT" "auth.krapulax.dev";
      description = "Public Dex/OIDC hostname.";
    };

    accountId = mkOption {
      type = types.str;
      default = envOr "OMNI_ACCOUNT_ID" "";
      description = "Omni account ID.";
    };

    initialUsers = mkOption {
      type = types.listOf types.str;
      default = lib.optional (builtins.getEnv "OMNI_USER_EMAIL" != "") (builtins.getEnv "OMNI_USER_EMAIL");
      description = "Initial Omni users allowed to log in.";
    };

    bindAddr = mkOption {
      type = types.str;
      default = envOr "OMNI_BIND_ADDR" "0.0.0.0:8443";
      description = "Omni UI/API bind address.";
    };

    machineApiBindAddr = mkOption {
      type = types.str;
      default = envOr "OMNI_MACHINE_API_BIND_ADDR" "0.0.0.0:8095";
      description = "Omni machine API bind address.";
    };

    kubernetesProxyBindAddr = mkOption {
      type = types.str;
      default = envOr "OMNI_KUBERNETES_PROXY_BIND_ADDR" "0.0.0.0:8100";
      description = "Omni Kubernetes proxy bind address.";
    };

    eventSinkPort = mkOption {
      type = types.port;
      default = 8091;
      description = "Omni event sink port.";
    };

    wireguardBindAddr = mkOption {
      type = types.str;
      default = envOr "OMNI_SIDEROLINK_WIREGUARD_BIND_ADDR" "0.0.0.0:50180";
      description = "SideroLink WireGuard bind address.";
    };

    wireguardAdvertisedAddr = mkOption {
      type = types.str;
      default = envOr "OMNI_SIDEROLINK_WIREGUARD_ADVERTISED_ADDR" "omni.krapulax.dev:50180";
      description = "Public SideroLink WireGuard address advertised to Talos nodes.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    networking.hosts."127.0.0.1" = [
      cfg.authHostname
      cfg.hostname
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root - -"
      "d ${cfg.dataDir}/etcd 0750 root root - -"
      "d ${cfg.dataDir}/sqlite 0750 root root - -"
      "d ${cfg.dataDir}/dex 0750 root root - -"
    ];

    virtualisation.oci-containers.containers.dex = {
      image = "ghcr.io/dexidp/dex:v2.41.1";
      user = "0";
      ports = [
        "5556:5556"
      ];
      volumes = [
        "${cfg.secretsDir}/dex.yaml:/etc/dex/config.docker.yaml:ro"
        "${cfg.secretsDir}/server-chain.pem:/etc/dex/tls/server-chain.pem:ro"
        "${cfg.secretsDir}/server-key.pem:/etc/dex/tls/server-key.pem:ro"
        "${cfg.dataDir}/dex:/var/dex:rw"
      ];
      cmd = [
        "dex"
        "serve"
        "/etc/dex/config.docker.yaml"
      ];
      autoStart = true;
    };

    virtualisation.oci-containers.containers.omni = {
      image = cfg.image;
      dependsOn = ["dex"];
      volumes = [
        "${cfg.secretsDir}/ca.pem:/etc/ssl/certs/ca-certificates.crt:ro"
        "${cfg.secretsDir}/omni.asc:/omni.asc:ro"
        "${cfg.secretsDir}/omni.yaml:/etc/omni/omni.yaml:ro"
        "${cfg.secretsDir}/server-chain.pem:/server-chain.pem:ro"
        "${cfg.secretsDir}/server-key.pem:/server-key.pem:ro"
        "${cfg.dataDir}/etcd:/_out/etcd:rw"
        "${cfg.dataDir}/sqlite:/_out/sqlite:rw"
      ];
      cmd =
        [
          "--config-path=/etc/omni/omni.yaml"
          "--name=trinity"
          "--private-key-source=file:///omni.asc"
          "--cert=/server-chain.pem"
          "--key=/server-key.pem"
          "--machine-api-cert=/server-chain.pem"
          "--machine-api-key=/server-key.pem"
          "--bind-addr=${cfg.bindAddr}"
          "--machine-api-bind-addr=${cfg.machineApiBindAddr}"
          "--machine-api-advertised-url=${envOr "OMNI_MACHINE_API_ADVERTISED_URL" "https://${cfg.hostname}:${machineApiPort}/"}"
          "--advertised-api-url=${envOr "OMNI_ADVERTISED_API_URL" "https://${cfg.hostname}/"}"
          "--k8s-proxy-bind-addr=${cfg.kubernetesProxyBindAddr}"
          "--advertised-kubernetes-proxy-url=https://${cfg.hostname}:8100/"
          "--event-sink-port=${toString cfg.eventSinkPort}"
          "--siderolink-wireguard-bind-addr=${cfg.wireguardBindAddr}"
          "--siderolink-wireguard-advertised-addr=${cfg.wireguardAdvertisedAddr}"
          "--auth-auth0-enabled=false"
          "--auth-oidc-enabled=true"
          "--auth-oidc-provider-url=${envOr "OMNI_AUTH_PROVIDER_URL" "https://${cfg.authHostname}"}"
          "--auth-oidc-client-id=omni"
          "--auth-oidc-scopes=openid"
          "--auth-oidc-scopes=profile"
          "--auth-oidc-scopes=email"
          "--sqlite-storage-path=/_out/sqlite/omni.db"
        ]
        ++ optional (cfg.accountId != "") "--account-id=${cfg.accountId}"
        ++ map (user: "--initial-users=${user}") cfg.initialUsers;
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun"
        "--add-host=${cfg.authHostname}:127.0.0.1"
      ];
      autoStart = true;
    };

    networking.firewall.allowedTCPPorts = [
      8443
      (toInt machineApiPort)
      cfg.eventSinkPort
      8100
      5556
    ];
    networking.firewall.allowedUDPPorts = [
      50180
    ];
  };
}
