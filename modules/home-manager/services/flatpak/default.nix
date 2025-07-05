{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];

  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    services.flatpak = {
      enable = true;
      packages = [
        "us.zoom.Zoom"
      ];
      uninstallUnmanaged = true;
      update.auto.enable = false;
    };

    home.packages = [pkgs.flatpak];

    xdg.systemDirs.data = [
      "/var/lib/flatpak/exports/share"
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    ];
  };
}
