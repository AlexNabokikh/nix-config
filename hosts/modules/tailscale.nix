{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN";
  };

  config = mkIf config.tailscale.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = ["--ssh"];
    };
  };
}
