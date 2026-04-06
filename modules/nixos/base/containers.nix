{ ... }:
{
  flake.modules.nixos.containers = {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
