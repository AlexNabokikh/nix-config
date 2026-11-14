{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "uas"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Broadcom BCM4350 Bluetooth (0a5c:6412) patchram, not shipped in linux-firmware.
  hardware.firmware = [ pkgs.broadcom-bt-firmware ];

  # Intel Gen9 (Skylake Iris 540) GPU: i915 in the initrd for early KMS, plus VA-API and OpenCL runtimes.
  boot.initrd.kernelModules = [ "i915" ];
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver # iHD VA-API (primary)
    intel-vaapi-driver # i965 VA-API (fallback)
    intel-compute-runtime-legacy1 # OpenCL/Level Zero for Gen8-Gen11
  ];
}
