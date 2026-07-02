{
  flake.modules.nixos.services = {
    systemd.services = {
      NetworkManager-wait-online.enable = false;
      plymouth-quit-wait.enable = false;
    };
  };
}
