{ ... }:
{
  flake.modules.nixos.base = {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
