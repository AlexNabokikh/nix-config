# Module: Docker
# Purpose: Enables the Docker daemon + rootless Docker support.
# Platform: NixOS only
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.docker = {
    enable = lib.mkEnableOption "Docker (daemoned + rootless)";
  };

  config = mkIf config.docker.enable {
    virtualisation.docker.enable = true;
  };
}
