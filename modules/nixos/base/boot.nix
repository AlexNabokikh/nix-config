{ ... }:
{
  flake.modules.nixos.boot =
    { config, pkgs, ... }:
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
        kernelModules = [ "v4l2loopback" ];
        extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
        extraModprobeConfig = ''
          options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
        '';
      };
    };
}
