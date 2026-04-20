{
  flake.modules.nixos.desktopNiri =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
    };
}
