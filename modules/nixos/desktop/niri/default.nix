{ ... }:
{
  flake.modules.nixos.desktopNiri =
    { pkgs, ... }:
    {
      # Enable Niri
      programs.niri.enable = true;

      # Enable Xwayland
      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
    };
}
