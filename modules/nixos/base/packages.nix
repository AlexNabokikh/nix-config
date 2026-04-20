{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.localBinInPath = true;
      environment.systemPackages = with pkgs; [
        gcc
        gnumake
        killall
      ];
    };
}
