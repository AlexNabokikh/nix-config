{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault mkOption types;
in
{
  options.locale = {
    timezone = mkOption {
      type = types.str;
      description = "System timezone.";
    };
    default = mkOption {
      type = types.str;
      description = "Default system locale.";
    };
    extra = mkOption {
      type = types.attrsOf types.str;
      description = "Additional LC_* locale categories.";
    };
  };

  config = {
    user = {
      fullName = mkDefault "Alexander Nabokikh";
      email = mkDefault "alexander.nabokikh@olx.pl";
      gitKey = mkDefault "C5810093";
    };

    terminalFont = {
      family = mkDefault "MesloLGS Nerd Font Mono";
      package = mkDefault pkgs.nerd-fonts.meslo-lg;
      size = {
        linux = mkDefault 12;
        darwin = mkDefault 15;
      };
    };

    locale = {
      timezone = mkDefault "Europe/Warsaw";
      default = mkDefault "en_US.UTF-8";
      extra = mkDefault {
        LC_ADDRESS = "en_IE.UTF-8";
        LC_IDENTIFICATION = "en_IE.UTF-8";
        LC_MEASUREMENT = "en_IE.UTF-8";
        LC_MONETARY = "en_IE.UTF-8";
        LC_NAME = "en_IE.UTF-8";
        LC_NUMERIC = "en_IE.UTF-8";
        LC_PAPER = "en_IE.UTF-8";
        LC_TELEPHONE = "en_IE.UTF-8";
        LC_TIME = "en_IE.UTF-8";
      };
    };
  };
}
