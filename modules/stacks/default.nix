{ config, ... }:
let
  inherit (config.flake.modules) darwin nixos;
in
{
  imports = [
    ./linux-base.nix
    ./darwin-base.nix
    ./_compositor-base.nix
    ./hyprland.nix
    ./niri.nix
    ./aerospace.nix
  ];

  _module.args.stacks = {
    linuxBase = nixos.stackLinuxBase;
    hyprland = nixos.stackHyprland;
    niri = nixos.stackNiri;
    darwinBase = darwin.stackBase;
    aerospace = darwin.stackAerospace;
    _compositorBase = nixos._stackCompositorBase;
  };
}
