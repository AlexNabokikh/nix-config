{
  flake.modules.nixos.desktopCompositorCommon = {
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    services = {
      displayManager.gdm.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    security = {
      polkit.enable = true;
      pam.services.gdm.enableGnomeKeyring = true;
    };
  };
}
