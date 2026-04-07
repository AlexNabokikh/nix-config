{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "splash"
          "rd.udev.log_level=3"
        ];
        loader.efi.canTouchEfiVariables = true;
        loader.systemd-boot.enable = true;
        loader.timeout = 0;
        plymouth.enable = true;
      };
    };
}
