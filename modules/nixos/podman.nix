# System service only; CLI tools and the macOS docker shim live in home/programs/podman.nix.
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
