{ ... }:
{
  flake.modules.nixos.base = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
