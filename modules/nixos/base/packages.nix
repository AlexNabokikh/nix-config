{ ... }:
{
  flake.modules.nixos.packages =
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
