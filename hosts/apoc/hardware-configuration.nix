{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [];

  boot.initrd.availableKernelModules = ["ehci_pci" "xhci_pci" "usbhid" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a3af3854-701d-459f-941b-8dd88f08c0c3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F53C-7482";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  hardware.parallels.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["prl-tools"];
}
