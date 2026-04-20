{
  flake.modules.nixos.base = {
    systemd.services = {
      NetworkManager-wait-online.enable = false;
      plymouth-quit-wait.enable = false;
    };

    services.printing.enable = false;
    services.devmon.enable = true;
  };
}
