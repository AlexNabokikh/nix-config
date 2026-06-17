{
  flake.modules.nixos.boot =
    { pkgs, ... }:
    {
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [
          "quiet"
          "splash"
          "rd.udev.log_level=3"
        ];
        loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot.enable = true;
          timeout = 0;
        };
        plymouth.enable = true;
      };
    };
}
