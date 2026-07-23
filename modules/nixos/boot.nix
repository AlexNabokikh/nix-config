{
  flake.modules.nixos.boot = {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
        timeout = 0;
      };
      plymouth.enable = true;
    };

    systemd.services.plymouth-quit-wait.enable = false;
  };
}
