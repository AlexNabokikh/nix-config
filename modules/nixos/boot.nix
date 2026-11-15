{ pkgs, ... }:
{
  boot = {
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      timeout = 0;
    };
    plymouth.enable = true;
  };
}
