{...}: {
  imports = [
    ./arcane.nix
    ./cloudflared.nix
    ./traefik.nix
    ./beszel.nix
    ./whoami.nix
  ];
}
