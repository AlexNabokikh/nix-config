{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.xps.module = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./_hardware.nix
      nixos.base
      nixos.niri
    ];

    primaryUser = "nabokikh";
    system.stateVersion = "26.05";

    home-manager.sharedModules = [
      ({ lib, ... }: {
        xdg.configFile."niri/config.kdl".text = lib.mkAfter ''
          // Lock screen on lid close
          switch-events {
              lid-close { spawn "noctalia" "msg" "session" "lock"; }
          }
        '';
      })
    ];
  };
}
